# frozen_string_literal: true

require "iban_bic/version"
require "iban_bic/railtie" if defined?(Rails)
#require "iban_bic/engine" if defined?(Rails)
require "iban_bic/configuration"
require "iban_bic/iban_parts"
require "iban_bic/models/bic"

module IbanBic
  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    configuration.instance_eval(&Proc.new)
  end

  def calculate_check(iban)
    98 - "#{iban[4..-1]}#{iban[0..3]}".each_char.map do |char|
      case char
      when "0".."9" then char
      when "A".."Z" then (char.ord - 55).to_s
      else raise("Invalid IBAN")
      end
    end .join.to_i % 97
  end

  def calculate_bic(iban)
    country = iban[0..1]
    parts = IbanParser.partser[country].match(iban)
    return nil unless parts && parts[:bank]

    if ActiveRecord::Base.connection.table_exists? "bics"
      Bic.find_by(country: country, bank_code: parts[:bank]).pluck(:bic)
    else
      configuration.static_bics.dig(country, parts[:bank])
    end
  end

  module_function :configuration, :configure, :calculate_check, :calculate_bic
end

require "iban_bic/defaults"
