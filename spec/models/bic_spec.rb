# frozen_string_literal: true

require "rails_helper"

describe Bic, :db do
  subject(:bic) { Bic.new country: country, bank_code: bank_code, bic: bic_code }
  let(:country) { "ES" }
  let(:bank_code) { "1234" }
  let(:bic_code) { "ABCDESMM123" }

  it { is_expected.to be_valid }

  context "when bic is downcase" do
    let(:bic_code) { "abcdesmm123" }
    it { is_expected.to be_valid }
  end

  context "when bic doesn't include branch code" do
    let(:bic_code) { "ABCDESMM" }
    it { is_expected.to be_valid }
  end

  context "when country inside bic doesn't match country" do
    let(:country) { "PT" }
    it { is_expected.to be_invalid }
  end

  context "when bic format is invalid" do
    let(:bic_code) { "fsd234asd" }
    it { is_expected.to be_invalid }
  end

  context "when bic starts with a valid BIC" do
    let(:bic_code) { "ABCDESMMX" }
    it { is_expected.to be_invalid }
  end

  context "when bic ends with a valid BIC" do
    let(:bic_code) { "1ABCDESMM" }
    it { is_expected.to be_invalid }
  end

  context "when bic contains a valid BIC inside" do
    let(:bic_code) { "1ABCDESMMX" }
    it { is_expected.to be_invalid }
  end
end
