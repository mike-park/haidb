require 'spec_helper'

describe "dashboards" do

  context "without a login" do
    it "should redirect to login page" do
      visit users_dashboards_path
      page.should have_css('.sessions.new')
    end
  end

  context "with a valid login" do
    let(:user) { FactoryGirl.create(:user, angel: angel) }

    before do
      user.confirm!
      user_login(user)
      visit users_dashboards_path
    end

    context "without an angel" do
      let(:angel) { nil }
      it "should redirect to profil page" do
        expect(page).to have_css('.angels.new')
      end
    end

    context "with an angel" do
      let(:angel) { create(:angel) }
      it "should show the dashboard page" do
        expect(page).to have_css('.dashboards.index')
      end
    end
  end
end
