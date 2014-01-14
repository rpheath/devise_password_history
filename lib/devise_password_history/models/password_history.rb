require "active_support/concern"

module Devise
  module Models
    module PasswordHistory
      extend ActiveSupport::Concern

      module ClassMethods
        Devise::Models.config(self, :password_history_count, :deny_old_passwords)
      end

      included do
        has_many :old_passwords, :as => :password_history, :dependent => :destroy
        before_update :store_old_password
        validate :validate_old_passwords
      end

      # validation applied here
      def validate_old_passwords
        if self.encrypted_password_changed? && self.old_password_being_used?
          self.errors.add(:password, "has been used already (you can't use your last #{self.class.password_history_count} passwords)")
        end
      end

      def old_password_being_used?
        if active_password_history_support?
          if self.password.present?
            # we need to go through each of the old passwords
            # and check to see if the new password would authenticate
            # the user (via valid_password?); if so that indicates
            # the password has been used in the past
            self.old_passwords.each do |old_pw|
              temp = self.class.new
              temp.encrypted_password = old_pw.encrypted_password
              temp.password_salt = old_pw.password_salt

              # return true if this password "passes" (authenticates)
              return true if temp.valid_password?(self.password)
            end
          end
        end

        # otherwise, we're safe to let this
        # password go through
        false
      end

    protected
      # make sure this is turned on in the Devise config
      def should_deny_old_passwords?
        self.class.deny_old_passwords.is_a?(TrueClass)
      end

      # count needs to be above zero
      def valid_password_history_count?
        self.class.password_history_count > 0
      end

      # is this extension configured properly (active)?
      def active_password_history_support?
        self.should_deny_old_passwords? && self.valid_password_history_count?
      end

      # stores the old password in the database;
      # removes passwords past the configured threshold
      def store_old_password
        # only do this if the password has been modified
        if self.encrypted_password_changed?
          if self.valid_password_history_count?
            # record the old password
            old_pw = self.old_passwords.new
            old_pw.encrypted_password = self.encrypted_password_change.first
            old_pw.password_salt = self.password_salt_change.first if self.password_salt_change.present?
            old_pw.save!

            # wipe out passwords beyond our desired count
            expired_passwords = self.old_passwords.order(:id).reverse_order.offset(self.class.password_history_count)
            expired_passwords.destroy_all if expired_passwords.present?
          else
            # if the count is zero, no password history
            self.old_passwords.destroy_all
          end
        end
      end
    end
  end
end