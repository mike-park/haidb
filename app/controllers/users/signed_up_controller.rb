class Users::SignedUpController < Users::ApplicationController
  skip_before_filter :authenticate_user!
  layout 'application'

  def new
  end
end