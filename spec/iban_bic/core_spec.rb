# frozen_string_literal: true

require "rails_helper"

RSpec.describe(::IbanBic) do
  let(:iban) { "ES#{iban_digits}00030000#{country_digits}0000000000" }
  let(:iban_digits) { "87" }
  let(:country_digits) { "30" }

  describe "#calculate_check" do
    subject(:method) { IbanBic.calculate_check(iban) }

    it { is_expected.to eq(97) }

    context "when control digits are wrong" do
      let(:iban_digits) { "15" }

      it { is_expected.not_to eq(97) }
    end

    context "when control digits are zeros" do
      let(:iban_digits) { "00" }

      it { is_expected.to eq(87) }
    end

    context "when iban format is invalid" do
      let(:iban) { "ES+" }

      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end

  describe "#calculate_bic" do
    subject(:method) { IbanBic.calculate_bic(iban) }

    context "when using database entries" do
      before do
        new_bic = Bic.find_or_initialize_by(country: "ES", bank_code: "0003")
        new_bic.bic = "DIFFERENT"
        new_bic.save!
        IbanBic.clear_cache
      end
      it { is_expected.to eq("DIFFERENT") }
    end

    context "when using static bics" do
      before { IbanBic.configuration.use_static_bics = true }
      after { IbanBic.configuration.use_static_bics = false }
      it { is_expected.to eq("BDEPESM1XXX") }
    end

    context "when bank code is unknown" do
      let(:iban) { "ES0000000000300000000000" }

      it { is_expected.to be_nil }
    end
  end

  describe "#fix" do
    subject(:method) { IbanBic.fix(iban) }
    let(:correct_iban) { "ES8700030000300000000000" }

    it { is_expected.to eq(correct_iban) }

    context "when control digits are wrong" do
      let(:iban_digits) { "15" }

      it { is_expected.to eq(correct_iban) }
    end

    context "when country control digits are wrong" do
      let(:country_digits) { "32" }

      it { is_expected.to eq(correct_iban) }
    end

    context "when both control digits are wrong" do
      let(:iban_digits) { "15" }
      let(:country_digits) { "32" }

      it { is_expected.to eq(correct_iban) }
    end

    context "when country has fixed iban check digits" do
      let(:iban) { "PT#{iban_digits}0000000000000000000#{country_digits}" }
      let(:correct_iban) { "PT50000000000000000000098" }
      let(:iban_digits) { "50" }
      let(:country_digits) { "98" }

      it { is_expected.to eq(correct_iban) }

      context "when control digits are wrong" do
        let(:iban_digits) { "42" }

        it { is_expected.to eq(correct_iban) }
      end

      context "when country control digits are wrong" do
        let(:country_digits) { "17" }

        it { is_expected.to eq(correct_iban) }
      end

      context "when both control digits are wrong" do
        let(:iban_digits) { "41" }
        let(:country_digits) { "17" }

        it { is_expected.to eq(correct_iban) }
      end
    end

    context "when iban format is invalid" do
      let(:iban) { "ES+" }

      it { is_expected.to be_nil }
    end
  end

  describe "#has_tags?" do
    subject(:method) { IbanBic.has_tags?(iban, tags) }
    let(:tags) { [:sepa] }

    it { is_expected.to be_truthy }

    context "when the country does not have the tags" do
      let(:tags) { [:fixed_iban_check] }

      it { is_expected.to be_falsey }
    end
  end

  describe "#like_pattern" do
    subject(:method) { IbanBic.like_pattern(iban, *parts) }
    let(:parts) { [:bank, :check] }

    it { is_expected.to eq("____0003____#{country_digits}__________") }
  end

  describe "#like_pattern_from_parts" do
    subject(:method) { IbanBic.like_pattern_from_parts(country: "ES", bank: "0003") }

    it { is_expected.to eq("ES__0003________________") }
  end

  describe "#parse" do
    subject(:method) { IbanBic.parse(iban) }

    it { is_expected.to include(country: "ES", bank: "0003", branch: "0000", check: country_digits, account: "0000000000") }
  end

  describe "#valid?" do
    subject(:method) { IbanBic.valid?(iban) }

    it { is_expected.to be_truthy }

    context "when iban is invalid" do
      let(:iban_digits) { "00" }

      it { is_expected.to be_falsey }
    end

    context "when country control digits are wrong" do
      let(:country_digits) { "12" }

      it { is_expected.to be_falsey }
    end
  end

  describe "#valid_check?" do
    subject(:method) { IbanBic.valid_check?(iban) }

    it { is_expected.to be_truthy }

    context "when iban is invalid" do
      let(:iban_digits) { "00" }

      it { is_expected.to be_falsey }
    end
  end

  describe "#valid_country_check?" do
    subject(:method) { IbanBic.valid_country_check?(iban) }

    it { is_expected.to be_truthy }

    context "when country control digits are wrong" do
      let(:country_digits) { "12" }

      it { is_expected.to be_falsey }
    end
  end
end
