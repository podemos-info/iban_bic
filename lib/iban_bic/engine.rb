# frozen_string_literal: true

require "active_model/validations/bic_validator"
require "active_model/validations/iban_validator"

module IbanBic
  class Engine < ::Rails::Engine
    paths["app/models"] << "lib/iban_bic/models"
  end
end
