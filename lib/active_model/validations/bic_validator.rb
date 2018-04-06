# frozen_string_literal: true

require "active_model/validations"
require "iban_bic"

# ActiveModel Rails module.
module ActiveModel
  # ActiveModel::Validations Rails module. Contains all the default validators.
  module Validations
    class BicValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        country_field = options[:country] ? record[options[:country]] : "[A-Z]{2}"
        record.errors.add(attribute, :invalid_format) unless /^[A-Z]{4}#{country_field}[0-9A-Z]{2}([0-9A-Z]{3})?$/.match? value.upcase
      end
    end
  end
end
