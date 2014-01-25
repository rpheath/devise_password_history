module DevisePasswordHistory
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        append_before_filter :check_password_expiration
      end

    protected  
      def check_password_expiration
        # skip if we don't have a user
        return if current_user.blank?
        # skip if we're on the controller that needs
        # to update the passwords (infinite loop otherwise)
        return if self.class.to_s == update_password_controller.to_s

        if current_user.has_password_expired?
          flash[:alert] = expired_password_message
          redirect_to update_password_path 
        end
      end

      # path to update passwords (can be overridden)
      def update_password_path
        edit_admin_user_path(current_user)        
      end

      # the controller that handles password 
      # updating (can be overridden)
      def update_password_controller
        "Admin::UsersController"
      end

      # flash message
      def expired_password_message
        "Your password has expired, please choose a new one"
      end
    end
  end
end