# frozen_string_literal: true

require "active_model/validations"
require "iban_bic"

# ActiveModel Rails module.
module ActiveModel
  # ActiveModel::Validations Rails module. Contains all the default validators.
  module Validations
    class IbanValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if !IbanBic.parse(value)
          record.errors.add(attribute, :invalid_format)
        elsif !IbanBic.valid_check?(value)
          record.errors.add(attribute, :invalid_check)
        elsif !IbanBic.valid_country_check?(value)

          record.errors.add(attribute, :invalid_country_check)
        end
      end
    end
  end
end
