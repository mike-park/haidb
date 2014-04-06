# -*- coding: utf-8 -*-
require 'spec_helper'

describe "GET /public_signups/new" do
  def should_have_common_elements
    page.should have_selector('form')
    page.should have_field('public_signup[registration_attributes][first_name]')
  end

  def visit_de_in_english
    page.should have_selector('label', :text => "First name")
    page.should have_selector('.title', :text => "public_signup.form.title")
    page.should have_selector('#public_signup_registration_attributes_payment_method_debt')
    page.should have_link('Deutsch hier an')
    page.should have_selector('#public_signup_registration_attributes_backjack_rental_false')
    page.should have_selector('option', text: 'Germany')
  end

  def visit_de_in_german
    page.should have_selector('label', :text => "Vorname")
    page.should have_selector('.title', :text => "public_signup.form.title")
    page.should have_selector('#public_signup_registration_attributes_payment_method_debt')
    page.should have_link('register in English')
    page.should have_selector('label', :text => 'Zahlungsart')
    page.should have_selector('#public_signup_registration_attributes_backjack_rental_false')
    page.should have_selector('option', text: 'Deutschland')
  end

  def visit_uk_in_english
    page.should have_selector('label', :text => "First name")
    page.should have_selector('.title', :text => "public_signup.form.title")
    page.should have_no_selector('#public_signup_registration_attributes_payment_method_debt')
    page.should have_no_link('Deutsch hier an')
    page.should have_no_content("To pay for the workshop")
    page.should have_no_selector('#public_signup_registration_attributes_backjack_rental_false')
    page.should have_selector('option', text: 'United Kingdom')
  end

  context "de site" do
    before(:each) { Site.stub(:name).and_return('de') }
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
  end

  context "uk site" do
    before(:each) do
      Site.stub(:name).and_return('uk')
      I18n.locale = :en
    end

    it "should render in English" do
      visit "/"
      #save_and_open_page
      should_have_common_elements
      visit_uk_in_english
    end
  end
end

def should_have_n_records(n)
  Event.all.count.should == 1
  Registration.all.count.should == n
  Angel.all.count.should == n
  PublicSignup.approved.count.should == 0
  PublicSignup.waitlisted.count.should == 0
  PublicSignup.pending.count.should == n
end

describe "POST /public_signups" do
  let(:future_event) { FactoryGirl.create(:future_event) }
  before(:each) do
    Site.stub(:name).and_return('de')
    future_event
  end

  def create_en_public_signup
    should_have_n_records(0)
    visit "/en"
    select(future_event.display_name, from: "Event")
    fill_in "First name", with: "John"
    fill_in "Last name", with: 'Smith'
    choose('Male')
    #save_and_open_page
    choose('Money transfer')
    fill_in "Email", with: "jsmith@example.com"
    check "public_signup_terms_and_conditions"

    click_button "Sign me up!"
    should_have_n_records(1)
    angel = Angel.first
    angel.lang.should == 'en'
    angel.first_name.should == 'John'
    angel.last_name.should == 'Smith'
  end

  def waitlist_signup
    visit "/office/public_signups"
    click_link "Show"
    click_link "Waitlist"
    #save_and_open_page
    page.should have_content("John Smith has been waitlisted")
    PublicSignup.waitlisted.count.should == 1
    PublicSignup.approved.count.should == 0
    PublicSignup.pending.count.should == 0
  end

  def approve_signup
    visit "/office/public_signups"
    #save_and_open_page
    click_link "Wait listed"
    click_link "Show"
    click_link "Approve"
    page.should have_content("John Smith has been successfully added")
    PublicSignup.waitlisted.count.should == 0
    PublicSignup.approved.count.should == 1
    PublicSignup.pending.count.should == 0
  end

  it "should save an English signup" do
    create_en_public_signup
  end

  it "should save a German signup" do
    visit "/de"
    # noinspection RubyArgCount
    select(future_event.display_name, from: "Event")
    fill_in "Vorname", with: "John"
    fill_in "Name", with: 'Smith', match: :prefer_exact
    choose('männlich')
    choose('Direkt')
    fill_in "Emailadresse", with: "jsmith@example.com"
    check "public_signup_terms_and_conditions"

    click_button "Melden Sie mich an!"
    Event.all.count.should == 1
    Registration.all.count.should == 1
    Angel.all.count.should == 1
    Angel.first.lang.should == 'de'
  end

  context "public_signup workflow" do
    before do
      office_login
    end

    it "should allow public_signup to be waitlisted, then approved" do
      create_en_public_signup
      waitlist_signup
      approve_signup
    end
  end
end