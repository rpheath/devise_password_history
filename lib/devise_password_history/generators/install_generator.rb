require "rails/generators"
require "rails/generators/base"

module DevisePasswordHistory
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)
      
      desc "Install the devise password history extension"

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S").to_i.to_s
      end

      def add_configs
        inject_into_file "config/initializers/devise.rb", "\n  # ==> Password History\n" +
          "  # How many old passwords to keep and validate against\n" +
          "  config.password_history_count = 8\n\n" +
          "  # Toggles behavior for Deny/Allow old passwords\n" +
          "  config.deny_old_passwords = true\n\n" +        
          "  # Repeatedly forces a new password based on this age\n" +
          "  # config.password_age = 90.days\n\n" +        
          "", :before => /end[\s|\n|]+\Z/
      end

      def copy_models
        copy_file "models/old_password.rb", "app/models/old_password.rb"
      end

      def copy_migrations
        migration_template "migrations/create_old_passwords.rb", "db/migrate/create_old_passwords.rb"
      end

      def copy_locale
        copy_file "../../../../config/locales/en.yml", "config/locales/devise_password_history.en.yml"
      end
    end
  end
end