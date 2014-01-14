class OldPassword < ActiveRecord::Base
  belongs_to :password_history, :polymorphic => true
end