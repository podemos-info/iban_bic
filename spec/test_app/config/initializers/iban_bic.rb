# frozen_string_literal: true

IbanBic.configure do |config|
  config.bics_table_name = "bics"
  config.use_static_bics = false

  # add [country_code] do |parts|
  #   Here change the check parts (check, check2) to make other parts (bank, branch, account) satify country checks
  # end

  # config.iban_meta_path = "path/iban_meta.yml"
  # config.static_bics_path = "path/bics/"
end
