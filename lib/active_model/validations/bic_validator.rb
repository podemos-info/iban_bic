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
        unless /[A-Z]{4}#{country_field}[0-9A-Z]{2,5}/.match? value.upcase
          record.errors.add(attribute, :invalid_format)
        end
      end
    end
  end
end
