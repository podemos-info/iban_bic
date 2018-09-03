# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require "iban_bic/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "iban_bic"
  s.version = IbanBic::VERSION
  s.authors = ["Leonardo Diez"]
  s.email = ["leiodd@gmail.com"]
  s.homepage = "https://github.com/podemos-info/iban_bic"
  s.summary = "IBAN and BIC tools for Rails applications"
  s.description = "When IBAN validation is not enough"
  s.license = "MIT"

  s.files = Dir["{data,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1"
  s.add_dependency "regexp-examples", "~> 1.3"

  s.add_development_dependency "codecov", "~> 0.1"
  s.add_development_dependency "generator_spec", "~> 0.9.3"
  s.add_development_dependency "rspec-rails", "~> 3.6"
  s.add_development_dependency "rubocop", "~> 0.54.0"
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "virtus", "~> 1.0"
end
