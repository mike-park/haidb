require 'spec_helper'

describe "registrations" do
  it "should redirect to login page" do
    visit users_registrations_path
    page.should have_css('.sessions.new')
  end

  context "with a valid login" do
    let(:registration) { create(:full_registration) }
    let(:user) { create(:user, angel: registration.angel) }

    before do
      user.confirm!
      user_login(user)
    end

    it "should show the registration page" do
      visit users_registrations_path
      page.should have_css('.registrations.index')
    end

    it "should show registration" do
      visit users_registrations_path
      page.should have_content(registration.event_name)
    end

    it "should have a roster link" do
      registration.update_attributes(approved: true, completed: true)
      visit users_registrations_path
      page.should have_selector('a', text: registration.event_name)
    end

    it "should not have a roster link" do
      registration.update_attributes(approved: true, completed: false)
      visit users_registrations_path
      page.should_not have_selector('a', text: registration.event_name)
    end
  end
end
