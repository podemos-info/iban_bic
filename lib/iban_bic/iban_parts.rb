# frozen_string_literal: true

module IbanBic
  class IbanParts
    include Singleton

    def parse(iban)
      partser[iban[0..1]]&.match(iban)
    end

    private

    def partser
      @partser ||= Hash[
        YAML.load_file(IbanBic.configuration.iban_meta_path).map do |country, meta|
          [country, /^(?<country>#{country})#{meta["parts"].delete(" ")}$/]
        end
      ].freeze
    end
  end
end
