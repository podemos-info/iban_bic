# frozen_string_literal: true

namespace :iban_bic do
  desc "Load static data to the database"
  task load_data: :environment do
    require "iban_bic"

    IbanBic.configuration.static_bics.each do |country, data|
      data.each do |bank_code, bic|
        Bic.find_or_create_by(country: country, bank_code: bank_code) do |new_bic|
          new_bic.bic = bic
        end
      end
    end
  end
end
