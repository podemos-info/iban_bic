# frozen_string_literal: true

require "iban_bic"

module IbanBic
  class IbanValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      iban_parts = IbanParts.instance.parse(value)

      if !iban_parts || IbanBic.calculate_check(value) != 97
        record.errors.add(attribute, :invalid)
      elsif !country_valid?(iban_parts)
        record.errors.add(attribute, :invalid_country)
      end
    end

    private

    def country_valid?(iban_parts)
      validator = IbanBic.configuration.country_validators[iban_parts[:country]]
      validator.nil? || validator.call(iban_parts)
    end
  end
end
