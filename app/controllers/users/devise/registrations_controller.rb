class Users::Devise::RegistrationsController < Devise::RegistrationsController
  layout 'users', only: [:edit, :update]

  protected

  def after_inactive_sign_up_path_for(resource)
    users_signup_requested_path
  end
end