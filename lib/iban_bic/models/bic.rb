# frozen_string_literal: true

module IbanBic
  class Bic < ActiveRecord::Base
    self.table_name = "bics"
  end
end
