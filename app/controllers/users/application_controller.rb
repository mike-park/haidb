class Users::ApplicationController < ApplicationController
  before_filter :authenticate_user!

  layout 'users/application'

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to users_root_url, :alert => exception.message
  end
end
