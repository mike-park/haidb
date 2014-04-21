require 'spec_helper'

describe "rosters" do
  let(:does_not_exist_id) { 999 }

  context "without a login" do
    it "should redirect to new session" do
      visit users_roster_path(id: does_not_exist_id)
      page.should have_css('.sessions.new')
    end
  end

  context "with a valid login" do
    let(:angel) { create(:angel) }
    let(:registration) { create(:registration, angel: angel) }
    let(:event) { registration.event }
    let(:user) { create(:user, angel: angel) }
    let(:no_auth) { 'You are not authorized to access page' }

    before do
      user_login(user)
    end

    it "should handle invalid roster ids" do
      visit users_roster_path(id: does_not_exist_id)
      page.should have_content(no_auth)
    end

    it "should not show the roster" do
      visit users_roster_path(id: event.id)
      page.should have_content(no_auth)
    end

    it "should not show the roster, even when approved." do
      registration.approve
      registration.save!
      visit users_roster_path(id: event.id)
      page.should have_content(no_auth)
    end

    it "should show the roster, when approved & completed." do
      registration.approve
      registration.update_attributes(completed: true)
      visit users_roster_path(id: event.id)
      page.should_not have_content(no_auth)
      page.should have_selector('td', text: registration.full_name)
      page.should have_selector('td', text: registration.email)
    end

    it "should not show the roster if we are not part of the event" do
      registration.approve
      registration.update_attributes(completed: true)
      registration.update_attribute(:angel, build(:angel))
      visit users_roster_path(id: event.id)
      page.should have_content(no_auth)
    end
  end
end
