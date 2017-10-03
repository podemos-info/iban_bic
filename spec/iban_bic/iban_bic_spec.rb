# frozen_string_literal: true

require "spec_helper"
require "iban_bic"

RSpec.describe(::IbanBic) do
  describe "#valid_check?" do
    subject(:method) { IbanBic.valid_check?(iban) }
    let(:iban) { "ES8023100001180000012345" }

    it { is_expected.to be_truthy }

    context "when iban is invalid" do
      let(:iban) { "ES0000000000000000000000" }

      it { is_expected.to be_falsey }
    end
  end

  describe "#calculate_check" do
    subject(:method) { IbanBic.calculate_check(iban) }
    let(:iban) { "ES8023100001180000012345" }

    it { is_expected.to eq(97) }

    context "return other values when control digits are wrong" do
      let(:iban) { "ES1023100001180000012345" }

      it { is_expected.not_to eq(97) }
    end

    context "calculates control digit when they are 'missing'" do
      let(:iban) { "ES0023100001180000012345" }

      it { is_expected.to eq(80) }
    end
  end
end
