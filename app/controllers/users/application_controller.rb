class Users::ApplicationController < ApplicationController
  layout 'users/application'

  before_filter :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to users_root_url, :alert => exception.message
  end
end
