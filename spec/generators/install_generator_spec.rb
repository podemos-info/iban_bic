# frozen_string_literal: true

require "spec_helper"
require "generator_spec/test_case"
require File.expand_path("../../../lib/generators/iban_bic/install_generator", __FILE__)

RSpec.describe IbanBic::InstallGenerator, type: :generator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../tmp", __FILE__)

  after(:all) { prepare_destination } # cleanup the tmp directory

  describe "no options" do
    before(:all) do
      prepare_destination
      run_generator
    end

    it "generates a migration for creating the 'bics' table" do
      expect(destination_root).to(
        have_structure do
          directory("db") do
            directory("migrate") do
              migration("create_bics") do
                contains "class CreateBics"
                contains "def change"
                contains "create_table :bics"
              end
            end
          end
        end
      )
    end

    it "generates an initializer" do
      expect(destination_root).to(
        have_structure do
          directory("config") do
            directory("initializers") do
              file("iban_bic.rb")
            end
          end
        end
      )
    end
  end

  describe "`--with-static-bics` option set to `true`" do
    before(:all) do
      prepare_destination
      run_generator %w(--with-static-bics)
    end

    it "does not generates a migration for creating the 'bics' table" do
      expect(destination_root).not_to(
        have_structure do
          directory("db") do
            directory("migrate") do
              migration("create_bics")
            end
          end
        end
      )
    end

    it "generates an initializer" do
      expect(destination_root).to(
        have_structure do
          directory("config") do
            directory("initializers") do
              file("iban_bic.rb")
            end
          end
        end
      )
    end
  end

  describe "`--bics-table-name` option changed" do
    before(:all) do
      prepare_destination
      run_generator %w(--bics-table-name=bics_mappings)
    end

    it "generates a migration for creating the 'bics_mappings' table" do
      expect(destination_root).to(
        have_structure do
          directory("db") do
            directory("migrate") do
              migration("create_bics") do
                contains "class CreateBics"
                contains "def change"
                contains "create_table :bics_mappings"
              end
            end
          end
        end
      )
    end

    it "generates an initializer" do
      expect(destination_root).to(
        have_structure do
          directory("config") do
            directory("initializers") do
              file("iban_bic.rb") do
                contains "config.bics_table_name = \"bics_mappings\""
              end
            end
          end
        end
      )
    end
  end
end
