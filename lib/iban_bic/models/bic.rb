# frozen_string_literal: true

class Bic < ActiveRecord::Base
  self.table_name = IbanBic.configuration.bics_table_name

  validates :country, :bank_code, :bic, presence: true

  validate do
    bic.upcase!
    unless /[A-Z]{4}#{country}[0-9A-Z]{2,5}/.match? bic
      errors.add(:bic, :invalid_format)
    end
  end

  after_commit do
    IbanBic.clear_cache
  end
end
