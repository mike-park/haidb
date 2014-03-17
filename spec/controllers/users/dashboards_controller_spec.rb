require 'spec_helper'

describe Users::DashboardsController do
  it "should require a valid login" do
    get :index
    response.should redirect_to(new_user_session_path)
  end
end