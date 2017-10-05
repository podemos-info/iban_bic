# frozen_string_literal: true

require "regexp-examples"

module IbanBic
  module_function

  def random_iban(options = {})
    country = options[:country]
    searched_tags = options[:tags]
    non_searched_tags = options[:not_tags]

    unless country
      possible_countries = random_generator.keys
      possible_countries -= IbanBic.tags.select { |_country, country_tags| (searched_tags - country_tags).any? } .keys if searched_tags.present?
      possible_countries -= IbanBic.tags.select { |_country, country_tags| (non_searched_tags & country_tags).any? } .keys if non_searched_tags.present?
      country = possible_countries.sample
    end
    IbanBic.fix(random_generator[country].random_example)
  end

  def random_generator
    @random_generator ||= Hash[
      iban_meta.map do |country, meta|
        [country, /^#{country}#{meta["parts"].delete(" ").gsub(/\(\?\<\w+\>([^\)]*)\)/, "\\1")}$/]
      end
    ].freeze
  end

  alias _clear_cache clear_cache
  def clear_cache
    _clear_cache
    @random_generator = nil
  end
end
