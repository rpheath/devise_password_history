# DevisePasswordHistory

This extension provides password history support for Devise,
which allows you to prevent users from re-using the same password
they've used in the past (the actual limit is configurable).

## Installation

Add this line to your application's Gemfile:

    gem 'devise_password_history'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise_password_history

## Usage

After installation, you need to "install" the extension into your
app via the following command:

    $ bundle exec rails g devise_password_history:install

That generator will do three things:

1. Modifies the `config/initializers/devise.rb` file with two new config options:
    - `config.deny_old_passwords`: turns the validations on/off
    - `config.password_history_count`: the threshold of how many passwords to store
2. Creates an `OldPassword` polymorphic model in `app/models`
3. Creates the migration for the `old_passwords` table

So once you run the generator, you just need to:

    $ bundle exec rake db:migrate

Now the extension has been installed. To use it, you tell `devise` like with
any of the other extensions:

    class User < ActiveRecord::Base
      devise :database_authenticatable, :password_history
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request