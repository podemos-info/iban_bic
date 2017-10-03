# frozen_string_literal: true

module IbanBic
  class Configuration
    attr_accessor :iban_meta_path, :use_static_bics, :bics_table_name
    attr_reader :static_bics_path

    def country_validators
      @country_validators ||= {}
    end

    def add(country)
      country_validators[country] = Proc.new
    end

    def static_bics_path=(value)
      @static_bics_path = value
      @static_bics = nil
    end

    def static_bics
      @static_bics ||= begin
        Hash[Dir.glob(File.join(static_bics_path, "*.yml")).map do |file|
          [File.basename(file).delete(".yml").upcase, YAML.load_file(file)]
        end].freeze
      end
    end

    def static_bics?
      use_static_bics
    end
  end
end
