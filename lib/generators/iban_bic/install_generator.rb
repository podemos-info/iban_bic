# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module IbanBic
  # Installs Iban+Bic in a rails app.
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path("templates", __dir__)

    class_option(
      :with_static_bics,
      type: :boolean,
      default: false,
      desc: "Don't create bics table, use static bics."
    )

    class_option(
      :bics_table_name,
      type: :string,
      default: "bics",
      desc: "BICs table name, `bics` by default."
    )

    desc "Generates an initializer file for configuring IbanBic." \
         " Also can generate a migration to add a bics table."

    def create_migration_file
      migration_template "create_bics.rb.erb", File.join("db", "migrate", "create_bics.rb") unless options.with_static_bics?
    end

    def create_initializer
      template "iban_bic.rb.erb", File.join("config", "initializers", "iban_bic.rb")
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def migration_version
      "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
    end

    def bics_table_name
      options.bics_table_name
    end

    def static_bics?
      options.with_static_bics?
    end
  end
end
