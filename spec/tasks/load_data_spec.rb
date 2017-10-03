# frozen_string_literal: true

require "rails_helper"

describe "rake iban_bic:load_data" do
  before do
    Bic.delete_all
    IbanBic.configuration.static_bics_path = File.expand_path("../data/bics/", __dir__)
  end

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "runs gracefully with no subscribers" do
    expect { task.execute }.not_to raise_error
  end

  it "logs to stdout" do
    expect { task.execute }.to output("Loading data.\nLoading 2 bank codes for country ES.\nAll data loaded.\n").to_stdout
  end

  it "create bics records" do
    expect { task.execute }.to change { Bic.count } .by(2)
  end
end
