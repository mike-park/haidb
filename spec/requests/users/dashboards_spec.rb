require 'spec_helper'

describe "users/dashboards" do
  it "should redirect to login page" do
    visit users_root_path
    page.should have_selector('h2', text: 'Sign in')
  end

  context "with a valid login" do
    let(:user) { FactoryGirl.create(:user) }
    let(:angel) { FactoryGirl.create(:angel, email: user.email)}
    let(:registration) { FactoryGirl.create(:registration, angel: angel, email: user.email) }

    before do
      user_login(user)
    end

    it "should show the dashboard page" do
      visit users_root_path
      page.should have_selector('body', text: '0 pending registrations')
    end

    it "should show 1 pending registration for future events" do
      registration.update_attribute(:event, FactoryGirl.create(:future_event))
      FactoryGirl.create(:public_signup, registration: registration)
      visit users_root_path
      page.should have_selector('body', text: '1 pending registration')
    end

    it "should show 0 pending registration for past events" do
      registration.update_attribute(:event, FactoryGirl.create(:past_event))
      FactoryGirl.create(:public_signup, registration: registration)
      visit users_root_path
      page.should have_selector('body', text: '0 pending registrations')
    end

    it "should show 1 signed up event when approved" do
      registration.update_attribute(:approved, true)
      visit users_root_path
      page.should have_selector('body', text: 'Signed up for 1 event')
    end

    it "should show 0 signed up events when not approved" do
      registration.update_attribute(:approved, false)
      visit users_root_path
      page.should have_selector('body', text: 'Signed up for 0 events')
    end

    it "should have a roster link" do
      registration.update_attributes(approved: true, completed: true)
      visit users_root_path
      page.should have_selector('a', text: 'Roster')
    end

    it "should not have a roster link" do
      registration.update_attributes(approved: true, completed: false)
      visit users_root_path
      page.should_not have_selector('a', text: 'Roster')
    end
  end
end
