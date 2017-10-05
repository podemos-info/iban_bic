# frozen_string_literal: true

module IbanBic
  class Configuration
    attr_accessor :iban_meta_path, :use_static_bics, :bics_table_name, :static_bics_path

    def add(country)
      IbanBic.country_validators[country] = Proc.new
    end

    def static_bics?
      use_static_bics
    end
  end
end
