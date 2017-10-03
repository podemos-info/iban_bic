# frozen_string_literal: true

def __bic_validation_proc(digits)
  ret = 11 - digits.chars.each_with_index.sum { |x, i| x.to_i * 2**i } % 11
  ret < 10 ? ret : 11 - ret
end

IbanBic.configure do
  add "ES" do |parts|
    parts[:check] == "#{__bic_validation_proc("00#{parts[:bank]}#{parts[:branch]}")}#{__bic_validation_proc(parts[:account])}"
  end
end
