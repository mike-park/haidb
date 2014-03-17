class Users::SignedInController < ApplicationController
  layout 'users/signed_in'

  before_filter :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    flash[:error] = 'You are not authorized to access this page.'
    redirect_to(request.referrer || users_root_path)
  end
end
