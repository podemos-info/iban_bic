# frozen_string_literal: true

require "rails_helper"
require "virtus"

describe ActiveModel::Validations::IbanValidator do
  subject(:validatable_model) { validatable.new(iban: iban) }

  let(:validatable) do
    Class.new do
      def self.model_name
        ActiveModel::Name.new(self, nil, "Validatable")
      end

      include Virtus.model
      include ActiveModel::Validations

      attribute :iban

      validates :iban, iban: true
    end
  end
  let(:iban) { "ES#{iban_digits}00030000#{country_digits}0000000000" }
  let(:iban_digits) { "87" }
  let(:country_digits) { "30" }

  it { is_expected.to be_valid }

  context "when invalid check digits" do
    let(:iban_digits) { "00" }
    it { is_expected.to be_invalid }
  end

  context "when invalid country digits" do
    let(:country_digits) { "00" }
    it { is_expected.to be_invalid }
  end

  context "when invalid format" do
    let(:iban) { "3432" }
    it { is_expected.to be_invalid }
  end
end
