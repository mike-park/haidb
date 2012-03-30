require 'spec_helper'

describe "users/rosters" do
  let(:does_not_exist_id) { 999 }

  it "should redirect to login page" do
    visit users_roster_path(id: does_not_exist_id)
    page.should have_selector('h2', text: 'User Sign in')
  end

  context "with a valid login" do
    let(:angel) { Factory.create(:angel, email: User.first.email)}
    let(:event) { Factory.create(:event) }
    let(:registration) { Factory.create(:registration, event: event, angel: angel) }

    users_login

    it "should not show the roster" do
      visit users_roster_path(id: event.id)
      page.should have_selector('body', text: 'You are not authorized to access this page')
    end

    it "should not show the roster, even when approved." do
      registration.update_attribute(:approved, true)
      visit users_roster_path(id: event.id)
      page.should have_selector('body', text: 'You are not authorized to access this page')
    end

    it "should show the roster, when approved & completed." do
      registration.update_attributes(approved: true, completed: true)
      visit users_roster_path(id: event.id)
      page.should_not have_selector('body', text: 'You are not authorized to access this page')
      page.should have_selector('td', text: angel.full_name)
      page.should have_selector('td', text: angel.email)
    end

    it "should not show the roster if we are not part of the event" do
      registration.update_attributes(approved: true, completed: true)
      angel.update_attribute(:email, 'not_ours@example.com')
      visit users_roster_path(id: event.id)
      page.should have_selector('body', text: 'You are not authorized to access this page')
    end

    it "should handle invalid roster ids" do
      visit users_roster_path(id: does_not_exist_id)
      page.should have_selector('body', text: "Couldn't find Event with id=#{does_not_exist_id}")
    end
  end
end


