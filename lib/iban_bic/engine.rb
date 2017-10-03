# frozen_string_literal: true

module IbanBic
  class Engine < ::Rails::Engine
    paths["app/models"] << "lib/iban_bic/models"
  end
end
