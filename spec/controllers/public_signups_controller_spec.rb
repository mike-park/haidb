# -*- coding: utf-8 -*-
require 'spec_helper'

describe PublicSignupsController do
  context "site specific switching" do
    render_views

    it "should render the correct form and layout" do
      %w(de uk).each do |name|
        Site.stub(:name).and_return(name)
        basedir = "public_signups/#{name}"
        # no top level new template, only in subdirectory. 
        [lambda { get :new, public_signup: {first_name: 'x'} },
         lambda { post :create, public_signup: {first_name: 'x'} }].each do |action|
          action.call
          response.should render_template(layout: "#{name}_site")
        end
      end
    end
  end

  describe "GET new" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have common default values" do
      get :new
      ps = assigns[:public_signup]
      ps.registration.role.should == Registration::PARTICIPANT
      ps.registration.payment_method == Registration::PAY_DEBT
      ps.registration.should_not be_approved
      ps.registration.lang.should == 'en'
    end

    it "should have DE specific default values" do
      Site.stub(:name).and_return('de')
      I18n.locale = :de
      get :new
      ps = assigns[:public_signup]
      ps.registration.payment_method == Registration::PAY_DEBT
      ps.registration.lang.should == 'de'
    end

    it "should have UK specific default values" do
      Site.stub(:name).and_return('uk')
      I18n.locale = :en
      get :new
      ps = assigns[:public_signup]
      ps.registration.payment_method == Registration::PAY_TRANSFER
      ps.registration.lang.should == 'en'
    end
  end

  describe "POST create" do
    before(:each) { I18n.locale = :en }

    it "should create public_signup object" do
      post :create, public_signup: {first_name: 'x'}
      assigns[:public_signup].should be
    end

    context "a valid signup" do
      let(:registration) { double('registration', find_or_initialize_angel: true) }
      let(:public_signup) { double("publicsignup", save: true, registration: registration, send_email: true) }
      let(:params) { { public_signup: { first_name: 'x'}}}
      before(:each) do
        PublicSignup.stub(:new).and_return(public_signup)
        Angel.stub(:add_to).with(registration)
      end

      it "should redirect_to site specific url" do
        success_url = 'https://somewhere.over.the.mountain/'
        SiteDefault.create!(description: 'desc',
                            translation_key_attributes: {
                                key: 'public_signup.form.success_url',
                                translations_attributes: [
                                    {locale: 'en', text: success_url}
                                ]})
        post :create, params
        response.should redirect_to(success_url)
        SiteDefault.destroy_all
      end

      it "should redirect to local url if no specific url exists" do
        post :create, params
        response.should redirect_to(public_signup_url(0))
      end

      it "should send notification email" do
        public_signup.should_receive(:send_email).with(EventEmail::SIGNUP)
        post :create, params
      end

      it "should receive a call to find angel" do
        registration.should_receive(:find_or_initialize_angel)
        post :create, params
      end
    end

    context "duplicate signups" do
      let(:event) { create(:event) }
      let(:signup) do
        {
            public_signup: attributes_for(:public_signup).merge(
                registration_attributes: attributes_for(:registration).merge(event_id: event.id))
        }
      end

      it "should not add the same angel to the same workshop" do
        post :create, signup
        expect(Registration.count).to eql(1)
        post :create, signup
        ps = assigns[:public_signup]
        expect(ps.errors.messages.keys).to include(:"registration.event_id")
      end
    end

    context "an invalid signup" do
      let(:invalid_attributes) { {registration_attributes: {payment_method: Registration::PAY_DEBT}} }
      before do
        Site.stub(:name).and_return('de')
      end

      it "should render new" do
        post :create, public_signup: invalid_attributes
        response.should render_template('new')
      end

      it "should not send notification email" do
        post :create, public_signup: invalid_attributes
        ActionMailer::Base.deliveries.count.should == 0
      end

      context "language of messages" do
        context "en" do
          before(:each) { I18n.locale = :en }
          it "should have English errors" do
            post :create, public_signup: invalid_attributes
            invalid_public_signup = assigns[:public_signup]
            invalid_public_signup.errors.messages.should == {
                :"registration.first_name" => ["can't be blank"],
                :"registration.last_name" => ["can't be blank"],
                :"registration.bank_account_name" => ["can't be blank"],
                :"registration.iban" => ["can't be blank"],
                :"registration.bic" => ["can't be blank"],
                :"registration.email" => ["can't be blank"],
                :"registration.gender" => ["must be selected"],
                :"registration.event" => ["must be selected"],
                :terms_and_conditions => ["must be accepted"]
            }
          end
        end
        context "de" do
          before(:each) { I18n.locale = :de }
          it "should have German errors" do
            post :create, public_signup: invalid_attributes
            invalid_public_signup = assigns[:public_signup]
            invalid_public_signup.errors.messages.should == {
                :"registration.first_name" => ["muss ausgefüllt werden"],
                :"registration.last_name" => ["muss ausgefüllt werden"],
                :"registration.email" => ["muss ausgefüllt werden"],
                :"registration.gender" => ["muss ausgewählt werden"],
                :"registration.event" => ["muss ausgewählt werden"],
                :"registration.bank_account_name" => ["muss ausgefüllt werden"],
                :"registration.bic" => ["muss ausgefüllt werden"],
                :"registration.iban" => ["muss ausgefüllt werden"],
                :terms_and_conditions => ["muss akzeptiert werden"]
            }
          end
        end
      end
    end
  end
end
