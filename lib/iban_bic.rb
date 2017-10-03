# frozen_string_literal: true

require "iban_bic/version"
require "iban_bic/configuration"
require "yaml"

module IbanBic
  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    configuration.instance_eval(&Proc.new)
  end

  def parse(iban)
    @parser ||= Hash[
      ::YAML.load_file(configuration.iban_meta_path).map do |country, meta|
        [country, /^(?<country>#{country})#{meta["parts"].delete(" ")}$/]
      end
    ].freeze

    parts = @parser[iban[0..1]]&.match(iban)
    parts ? ActiveSupport::HashWithIndifferentAccess[parts.names.zip(parts.captures)] : nil
  end

  def calculate_check(iban)
    98 - "#{iban[4..-1]}#{iban[0..3]}".each_char.map do |char|
      case char
      when "0".."9" then char
      when "A".."Z" then (char.ord - 55).to_s
      else raise ArgumentError, "Invalid IBAN format"
      end
    end .join.to_i % 97
  end

  def valid_check?(iban)
    calculate_check(iban) == 97
  end

  def valid_country_check?(iban)
    parts = parse(iban)
    validator = IbanBic.configuration.country_validators[parts[:country]]
    validator.nil? || validator.call(parts)
  end

  def calculate_bic(iban)
    country = iban[0..1]
    parts = parse(iban)
    return nil unless parts&.fetch(:bank, nil)

    if ActiveRecord::Base.connected? && ActiveRecord::Base.connection.table_exists?("bics")
      Bic.find_by(country: country, bank_code: parts[:bank]).pluck(:bic)
    else
      configuration.static_bics.dig(country, parts[:bank])
    end
  end

  module_function :configuration, :configure, :parse, :valid_check?, :valid_country_check?, :calculate_check, :calculate_bic

  autoload :Railtie, "iban_bic/railtie"
end

require "iban_bic/defaults"
