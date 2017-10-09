# frozen_string_literal: true

class Bic < ActiveRecord::Base
  self.table_name = IbanBic.configuration.bics_table_name

  validates :country, :bank_code, :bic, presence: true

  after_commit do
    IbanBic.clear_cache
  end
end
