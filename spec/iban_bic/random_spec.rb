# frozen_string_literal: true

require "rails_helper"
require "iban_bic/random"

RSpec.describe(::IbanBic) do
  describe "#random_iban" do
    subject(:method) { IbanBic.random_iban params }
    let(:params) { {} }

    it "returns a valid IBAN" do
      expect(IbanBic.valid?(subject)).to be_truthy
    end

    context "when a country code is given" do
      let(:params) { { country: "ES" } }

      it "returns a valid IBAN" do
        expect(IbanBic.valid?(subject)).to be_truthy
      end

      it "returns a valid IBAN from the country" do
        expect(subject[0..1]).to eq("ES")
      end
    end

    context "when tags are given" do
      let(:params) { { tags: [:sepa] } }

      it "returns a valid IBAN" do
        expect(IbanBic.valid?(subject)).to be_truthy
      end

      it "returns a valid IBAN from a country with that tags" do
        expect(IbanBic.has_tags?(subject, [:sepa])).to be_truthy
      end
    end

    context "when not_tags are given" do
      let(:params) { { not_tags: [:sepa] } }

      it "returns a valid IBAN" do
        expect(IbanBic.valid?(subject)).to be_truthy
      end

      it "returns a valid IBAN from a country without that tags" do
        expect(IbanBic.has_tags?(subject, [:sepa])).to be_falsey
      end
    end
  end
end
