# frozen_string_literal: true

IbanBic.configure do
  IBAN_BIC_PT_WEIGHTS_INDEX = [73, 17, 89, 38, 62, 45, 53, 15, 50, 5, 49, 34, 81, 76, 27, 90, 9, 30, 3].freeze

  add "PT" do |parts|
    nib = "#{parts[:bank]}#{parts[:branch]}#{parts[:account]}"
    sum = nib.chars.map(&:to_i).zip(IBAN_BIC_PT_WEIGHTS_INDEX).map { |a| a.inject(:*) } .sum
    parts[:check] = 98 - sum % 97
  end
end
