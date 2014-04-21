class Users::SignedInController < ApplicationController
  layout 'users'

  before_filter :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    flash[:alert] = 'You are not authorized to access page.'
    redirect_to(request.referrer || users_root_path)
  end
end
