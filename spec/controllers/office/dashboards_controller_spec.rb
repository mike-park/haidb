require 'spec_helper'

describe Office::DashboardsController do
  context "without login" do
    describe "GET index" do
      it "should redirect to login page" do
        get :index
        response.should redirect_to("/en/staffs/sign_in")
      end
    end
  end

  context "with login" do
    login_staff
  
    describe "GET index" do
      it "should be successful" do
        get :index
        response.should be_success
      end
    end
  end
end
