# frozen_string_literal: true

module IbanBic
  class Bic < ActiveRecord::Base
    self.table_name = IbanBic.configuration.table_name
  end
end
