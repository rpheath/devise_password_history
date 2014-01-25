require "active_support/concern"

require "devise"
require "devise_password_history/version"
require "devise_password_history/generators/install_generator"

# adds out config options to Devise
# (see config/initializers/devise.rb)
module Devise
  # How many old passwords to save
  mattr_accessor :password_history_count
  @@password_history_count = 8

  # Toggles the behavior of denying/allowing old passwords
  mattr_accessor :deny_old_passwords
  @@deny_old_passwords = true

  # Repeatedly forces a new password based on this age
  mattr_accessor :password_age
  @@password_age = nil
end

module DevisePasswordHistory
  module Controllers
    autoload :Helpers, "devise_password_history/controllers/helpers"
  end
end

# makes this module available to the `devise` command
Devise.add_module :password_history, :model => "devise_password_history/models/password_history"

require "devise_password_history/rails"