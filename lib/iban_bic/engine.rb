# frozen_string_literal: true

module IbanBic
  class Engine < ::Rails::Engine
    rake_tasks do
      load "tasks/load_data.rake"
    end
    paths["app/models"] << "lib/iban_bic/models"
  end
end
