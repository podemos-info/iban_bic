# frozen_string_literal: true

namespace :iban_bic do
  desc "Load static data to the database"
  task load_data: :environment do
    print "Loading data.\n"
    IbanBic.configuration.static_bics.each do |country, data|
      print "Loading #{data.length} bank codes for country #{country}.\n"
      data.each do |bank_code, bic|
        Bic.find_or_create_by(country: country, bank_code: bank_code) do |new_bic|
          new_bic.bic = bic
        end
      end
    end
    print "All data loaded.\n"
  end
end
