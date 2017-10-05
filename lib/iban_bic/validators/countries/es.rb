# frozen_string_literal: true

IbanBic.configure do
  def __iban_bic_es_bic_validation_proc(digits)
    ret = 11 - digits.chars.each_with_index.sum { |x, i| x.to_i * 2**i } % 11
    ret < 10 ? ret : 11 - ret
  end
  add "ES" do |parts|
    parts[:check] = "#{__iban_bic_es_bic_validation_proc("00#{parts[:bank]}#{parts[:branch]}")}#{__iban_bic_es_bic_validation_proc(parts[:account])}"
  end
end
