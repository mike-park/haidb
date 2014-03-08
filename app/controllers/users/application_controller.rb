class Users::ApplicationController < ApplicationController
  layout 'users/application'

  before_filter :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to users_root_url, :alert => exception.message
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    flash[:error] = 'You are not authorized to access this page.'
    redirect_to(request.referrer || users_root_path)
  end
end
