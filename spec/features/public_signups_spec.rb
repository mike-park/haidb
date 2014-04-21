# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'existing de link' do
  before do
    Site.stub(name: 'de')
  end

  it "should render de language" do
    visit '/de/public_signups/new?template_version=2'
    expect(page).to have_content('If you prefer you may register in English.')
  end
end

describe 'with site defaults' do
  before do
    SiteDefault.stub(get: 'something')
  end

  it "should have conditions" do
    expect(SiteDefault.get('public_signup.form.conditions')).to eq('something')
  end

  context "NEW" do
    def should_have_common_elements
      page.should have_selector('form')
      page.should have_field('public_signup[registration_attributes][first_name]')
    end

    def site_de_in_english
      page.should have_text("First name")
      page.should have_selector('#public_signup_registration_attributes_payment_method_debt')
      page.should have_link('Deutsch hier an')
      page.should have_selector('#public_signup_registration_attributes_backjack_rental_false')
      page.should have_selector('option', text: 'Germany')
    end

    def site_de_in_german
      page.should have_text("Vorname")
      page.should have_selector('#public_signup_registration_attributes_payment_method_debt')
      page.should have_link('register in English')
      page.should have_text('Zahlungsart')
      page.should have_selector('#public_signup_registration_attributes_backjack_rental_false')
      page.should have_selector('option', text: 'Deutschland')
    end

    def site_uk_in_english
      page.should have_text("First name")
      page.should have_no_selector('#public_signup_registration_attributes_payment_method_debt')
      page.should have_no_link('Deutsch hier an')
      page.should have_no_content("To pay for the workshop")
      page.should have_no_selector('#public_signup_registration_attributes_backjack_rental_false')
      page.should have_selector('option', text: 'United Kingdom')
    end

    context "de site" do
      before(:each) { Site.stub(:name).and_return('de') }
      it "should render in English" do
        visit "/?locale=en"
        should_have_common_elements
        site_de_in_english
      end

      it "should render in German" do
        visit "/?locale=de"
        should_have_common_elements
        site_de_in_german
      end

      it "should render both English & German" do
        visit "/?locale=en"
        #save_and_open_page
        site_de_in_english
        click_link "Deutsch"
        #save_and_open_page
        site_de_in_german
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
        site_uk_in_english
      end
    end
  end

  context "CREATE" do
    let(:future_event) { FactoryGirl.create(:future_event) }
    let(:de_fields) { ['Vorname', 'Name', 'männlich', 'Direkt', 'Emailadresse', 'Melden Sie mich an!', 'de'] }
    let(:en_fields) { ['First name', 'Last name', 'Male', 'Money transfer', 'Email', 'Sign me up!', 'en'] }

    before(:each) do
      Site.stub(:name).and_return('de')
      future_event
    end

    def should_have_n_records(n)
      Event.all.count.should == 1
      Registration.all.count.should == n
      Angel.all.count.should == n
      PublicSignup.approved.count.should == 0
      PublicSignup.waitlisted.count.should == 0
      PublicSignup.pending.count.should == n
    end

    def create_public_signup(args)
      should_have_n_records(0)
      select(future_event.display_name, from: "Event")
      fill_in args.slice!(0), with: "John"
      fill_in args.slice!(0), with: 'Smith', match: :prefer_exact
      choose(args.slice!(0))
      choose(args.slice!(0))
      fill_in args.slice!(0), with: "jsmith@example.com"
      check "public_signup_terms_and_conditions"

      click_button args.slice!(0)
      should_have_n_records(1)
      angel = Angel.first
      angel.lang.should == args.slice!(0)
      angel.first_name.should == 'John'
      angel.last_name.should == 'Smith'
    end

    it "should save an English signup" do
      visit "/?locale=en"
      create_public_signup(en_fields)
    end

    it "should save a German signup" do
      visit "/?locale=de"
      create_public_signup(de_fields)
    end
  end
end
