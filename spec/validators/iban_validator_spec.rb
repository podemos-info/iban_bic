# frozen_string_literal: true

require "rails_helper"
require "virtus"

describe ActiveModel::Validations::IbanValidator do
  subject(:validatable_model) { validatable.new(iban: iban) }

  let(:validatable) do
    options = validator_options
    Class.new do
      def self.model_name
        ActiveModel::Name.new(self, nil, "Validatable")
      end

      include Virtus.model
      include ActiveModel::Validations

      attribute :iban

      validates :iban, iban: options
    end
  end
  let(:iban) { "ES#{iban_digits}00030000#{country_digits}0000000000" }
  let(:iban_digits) { "87" }
  let(:country_digits) { "30" }
  let(:validator_options) { true }

  it { is_expected.to be_valid }

  context "when value is not present" do
    let(:iban) { nil }
    it { is_expected.to be_valid }
  end

  context "when invalid check digits" do
    let(:iban_digits) { "00" }
    it { is_expected.to be_invalid }
  end

  context "when invalid country digits" do
    let(:iban_digits) { "07" }
    let(:country_digits) { "00" }
    it "iban is valid" do
      expect(IbanBic.valid_check?(iban)).to be_truthy
    end
    it "but country digits not" do
      is_expected.to be_invalid
    end
  end

  context "when invalid format" do
    let(:iban) { "3432" }
    it { is_expected.to be_invalid }
  end

  describe "when tags option is present" do
    let(:validator_options) { { tags: tags } }
    let(:tags) { [:sepa] }
    it { is_expected.to be_valid }

    context "when tag is not present for the country" do
      let(:tags) { [:other] }
      it { is_expected.to be_invalid }
    end
  end
end
