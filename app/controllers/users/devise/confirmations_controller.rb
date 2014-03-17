class Users::Devise::ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_confirmation_path_for(resource_name, resource)
    users_confirmed_path
  end
end