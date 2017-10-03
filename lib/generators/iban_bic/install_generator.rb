# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module IbanBic
  # Installs Iban+Bic in a rails app.
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path("../templates", __FILE__)
    class_option(
      :with_static_bics,
      type: :boolean,
      default: false,
      desc: "Don't create bics table, use static bics."
    )

    desc "Generates an initializer file for configuring IbanBic." \
         " Also can generate a migration to add a bics table."

    def create_migration_file
      add_iban_bic_migration "create_bics" unless options.with_static_bics?
    end

    def create_initializer
      create_file "config/initializers/iban_bic.rb", <<~EOF
        # IbanBic.configure do
        #   add [country_code] do |parts|
        #     # Here test that parts (bank, branch, account and/or check) satifies national checks
        #   end
        # end
      EOF
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    protected

    def add_iban_bic_migration(template)
      migration_dir = File.expand_path("db/migrate")
      if self.class.migration_exists?(migration_dir, template)
        ::Kernel.warn "Migration already exists: #{template}"
      else
        migration_template(
          "#{template}.rb.erb",
          "db/migrate/#{template}.rb"
        )
      end
    end

    private

    def migration_version
      "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
    end
  end
end
