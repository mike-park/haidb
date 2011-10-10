require 'spec_helper'

describe "GET /public_signups/new" do
  def should_have_common_elements
    page.should have_selector('form')
    page.should have_field('public_signup[registration_attributes][angel_attributes][first_name]')
  end

  def visit_de_in_english
    page.should have_selector('label', :text => "First name")
    page.should have_selector('.title', :text => "Registration for HAI/Hand-on-Heart Workshop")
    page.should have_no_selector('#public_signup_registration_attributes_payment_method_input')
    page.should have_link('Deutsch hier an')
    page.should have_content("To pay for the workshop")
    page.should have_selector('#public_signup_registration_attributes_backjack_rental_input')
  end

  def visit_de_in_german
    page.should have_selector('label', :text => "Vorname")
    page.should have_selector('.title', :text => "Anmeldung")
    page.should have_selector('#public_signup_registration_attributes_payment_method_input')
    page.should have_link('register in English')
    page.should have_selector('label', :text => 'Zahlungsart')
    page.should have_selector('#public_signup_registration_attributes_backjack_rental_input')
  end

  def visit_uk_in_english
    page.should have_selector('label', :text => "First name")
    page.should have_selector('.title', :text => "Registration for HAI Workshop")
    page.should have_no_selector('#public_signup_registration_attributes_payment_method_input')
    page.should have_no_link('Deutsch hier an')
    page.should have_no_content("To pay for the workshop")
    page.should have_no_selector('#public_signup_registration_attributes_backjack_rental_input')
  end

  context "de site", :if => Site.de? do
    it "should render in English" do
      visit "/en"
      should_have_common_elements
      visit_de_in_english
    end

    it "should render in German" do
      visit "/de"
      should_have_common_elements
      visit_de_in_german
    end

    it "should render both English & German" do
      visit "/en"
      #save_and_open_page
      visit_de_in_english
      click_link "Deutsch"
      #save_and_open_page
      visit_de_in_german
    end

    it "should render in German by default" do
      visit "/"
      page.should have_content('Zahlungsart')
    end
  end

  context "uk site", :if => Site.uk? do
    it "should render in English" do
      visit "/"
      should_have_common_elements
      visit_uk_in_english
    end
  end
end

describe "POST /public_signups" do
  before(:each) do
    FactoryGirl.create(:future_event)
  end

  context "de site", if: Site.de? do
    it "should save an English signup" do
      visit "/en"
      fill_in "First name", with: "John"
      fill_in "Last name", with: 'Smith'

      click_button "Sign me up!"
      #save_and_open_page
      Event.all.count.should == 1
      Registration.all.count.should == 1
      Angel.all.count.should == 1
    end
  end
end