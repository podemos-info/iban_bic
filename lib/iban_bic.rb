# frozen_string_literal: true

require "yaml"
require "iban_bic/version"
require "iban_bic/configuration"
require "iban_bic/core"
require "iban_bic/engine" if defined?(Rails::Engine)
require "iban_bic/defaults"
