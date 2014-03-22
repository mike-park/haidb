require 'spec_helper'

describe "dashboards" do
  it "should redirect to login page" do
    visit users_dashboards_path
    page.should have_css('.sessions.new')
  end

  context "with a valid login" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      user.confirm!
      user_login(user)
    end

    it "should show the dashboard page" do
      visit users_dashboards_path
      page.should have_css('.dashboards.index')
    end
  end
end
