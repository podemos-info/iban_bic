# frozen_string_literal: true

require "spec_helper"
require "iban_bic"

RSpec.describe(::IbanBic) do
  let(:iban) { "ES#{iban_digits}00030000300000000000" }
  let(:iban_digits) { "87" }

  describe "#parse" do
    subject(:method) { IbanBic.parse(iban) }

    it { is_expected.to include(country: "ES", bank: "0003", branch: "0000", check: "30", account: "0000000000") }
  end

  describe "#valid_check?" do
    subject(:method) { IbanBic.valid_check?(iban) }

    it { is_expected.to be_truthy }

    context "when iban is invalid" do
      let(:iban_digits) { "00" }

      it { is_expected.to be_falsey }
    end
  end

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

    it { is_expected.to eq("BDEPESM1XXX") }
  end
end
