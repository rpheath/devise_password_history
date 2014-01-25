module DevisePasswordHistory
  class Engine < Rails::Engine
    ActiveSupport.on_load(:action_controller) do
      include DevisePasswordHistory::Controllers::Helpers
    end
  end
end