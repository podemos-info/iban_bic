# frozen_string_literal: true

class IbanBic::Railtie < Rails::Railtie
  rake_tasks do
    load "tasks/load_data.rake"
  end
end
