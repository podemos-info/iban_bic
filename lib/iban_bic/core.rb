# frozen_string_literal: true

module IbanBic
  module_function

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    configuration.instance_eval(&Proc.new)
  end

  def parse(iban)
    parts = parser[iban[0..1]]&.match(iban)
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

    bics.dig(country, parts[:bank])
  end

  def clear_cache
    @parser = @static_bics = @bics = nil
  end

  def parser
    @parser ||= Hash[
      ::YAML.load_file(configuration.iban_meta_path).map do |country, meta|
        [country, /^(?<country>#{country})#{meta["parts"].delete(" ")}$/]
      end
    ].freeze
  end

  def bics
    configuration.static_bics? ? static_bics : dynamic_bics
  end

  def static_bics
    @static_bics ||= Hash[Dir.glob(File.join(configuration.static_bics_path, "*.yml")).map do |file|
      [File.basename(file).delete(".yml").upcase, YAML.load_file(file)]
    end].freeze
  end

  def dynamic_bics
    @dynamic_bics ||= begin
      ret = Hash.new { |hash, key| hash[key] = {} }
      Bic.find_each do |bic|
        ret[bic.country][bic.bank_code] = bic.bic
      end
      ret.freeze
    end
  end
end
