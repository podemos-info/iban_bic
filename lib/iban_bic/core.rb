# frozen_string_literal: true

require "regexp-examples"

module IbanBic
  @cached_variables = []

  module_function

  def country_validators
    @country_validators ||= {}
  end

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

  def fix(iban)
    # Fixed check IBAN parts (countries where IBAN check is always the same) must be fixed before parsing
    iban, fixed_iban_check = fix_fixed_iban_check(iban)

    parts = parse(iban)
    return unless parts

    iban = calculate_valid_country_check_iban(iban)
    iban = fix_iban_check(iban) unless fixed_iban_check

    iban
  end

  def fix_fixed_iban_check(iban)
    return [iban, false] unless tags[iban[0..1]].member?(:fixed_iban_check)

    result = iban.dup
    result[2..3] = /\(\?\<iban_check>([^\)]*)\)/.match(iban_meta[iban[0..1]]["parts"])[1]
    [result, true]
  end

  def fix_iban_check(iban)
    result = iban.dup
    result[2..3] = "00"
    result[2..3] = calculate_check(result).to_s.rjust(2, "0")
    result.freeze
  end

  def has_tags?(iban, searched_tags)
    (tags[iban[0..1]] & searched_tags).any?
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

  def valid?(iban)
    valid_check?(iban) && valid_country_check?(iban)
  end

  def valid_check?(iban)
    calculate_check(iban) == 97
  end

  def calculate_valid_country_check_iban(iban)
    validator = country_validators[iban[0..1]]
    return iban unless validator

    parts = parse(iban)
    validator.call(parts)
    parts.values.join
  end

  def valid_country_check?(iban)
    calculate_valid_country_check_iban(iban) == iban
  end

  def calculate_bic(iban)
    country = iban[0..1]
    parts = parse(iban)
    return nil unless parts&.fetch(:bank, nil)

    bics.dig(country, parts[:bank])
  end

  def like_pattern(iban, *keep_parts)
    parts = IbanBic.parse(iban)
    parts.map { |part, value| keep_parts.include?(part.to_sym) ? value : value.tr("^_", "_") } .join
  end

  def like_pattern_from_parts(country:, **parts)
    ia_parts = parts.with_indifferent_access
    parser[country].to_s.scan(/\(?\<([^\>]+)\>([^\)]*)\)/).map do |part, regex|
      (part=="country" && country) || ia_parts[part] || Regexp.new(regex).examples.first.tr("^_", "_")
    end.join
  end

  def clear_cache
    @cached_variables.each { |variable| instance_variable_set(variable, nil) }
    @cached_variables.clear
  end

  def iban_meta
    @iban_meta ||= ::YAML.load_file(configuration.iban_meta_path)
  end

  def parser
    @parser ||= begin
      @cached_variables << :@parser
      Hash[
        iban_meta.map do |country, meta|
          [country, /^(?<country>#{country})#{meta["parts"].delete(" ")}$/]
        end
      ].freeze
    end
  end

  def tags
    @tags ||= begin
      @cached_variables << :@tags
      Hash[
        iban_meta.map do |country, meta|
          [country, meta["tags"]&.split&.map(&:to_sym) || []]
        end
      ].freeze
    end
  end

  def bics
    configuration.static_bics? ? static_bics : dynamic_bics
  end

  def static_bics
    @static_bics ||= begin
      @cached_variables << :@static_bics
      Hash[Dir.glob(File.join(configuration.static_bics_path, "*.yml")).map do |file|
        [File.basename(file).delete(".yml").upcase, YAML.load_file(file)]
      end].freeze
    end
  end

  def dynamic_bics
    @dynamic_bics ||= begin
      @cached_variables << :@dynamic_bics
      ret = {}
      Bic.find_each do |bic|
        ret[bic.country] = {} unless ret[bic.country]
        ret[bic.country][bic.bank_code] = bic.bic
      end
      ret.freeze
    end
  end
end
