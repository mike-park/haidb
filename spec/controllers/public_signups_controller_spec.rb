# -*- coding: utf-8 -*-
require 'spec_helper'

describe PublicSignupsController do
  before do
    I18n.locale = I18n.default_locale
  end

  context "site specific switching" do
    render_views

    it "should render the correct form and layout" do
      %w(de uk).each do |name|
        Site.stub(:name).and_return(name)
        basedir = "public_signups/#{name}"
        # no top level new template, only in subdirectory. 
        [lambda { get :new, public_signup: {x: 'x'} },
         lambda { post :create, public_signup: {x: 'x'} }].each do |action|
          action.call
          response.should render_template(layout: "#{name}_site")
        end
      end
    end
  end

  context "GET new" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    context "default values" do
      subject { assigns[:public_signup].registration }
      let(:site) { 'de' }
      let(:options) { {} }

      before do
        Site.stub(name: site)
        get :new, options
      end

      context "common default values" do
        its(:role) { Registration::PARTICIPANT }
        its(:approved) { false }
      end

      context "site DE specific default values" do
        let(:site) { 'de' }

        its(:payment_method) { eq(Registration::PAY_DEBT) }
        its(:lang) { eq('de') }

        context "with lang en" do
          let(:options) { {locale: 'en'} }

          its(:lang) { eq('en') }
        end
      end

      context "site UK specific default values" do
        let(:site) { 'uk' }

        its(:payment_method) { eq(Registration::PAY_TRANSFER) }
        its(:lang) { eq('en') }
      end
    end
  end

  context "POST create" do
    let(:event) { create(:event) }

    context "with a valid signup" do
      let(:signup_params) do
        {
            public_signup: attributes_for(:public_signup).merge(
                registration_attributes: attributes_for(:registration).merge(event_id: event.id))
        }
      end

      it "should send notification email" do
        PublicSignup.any_instance.should_receive(:send_email).with(EventEmail::SIGNUP)
        post :create, signup_params
      end

      it "should receive a call to find angel" do
        Registration.any_instance.should_receive(:find_or_initialize_angel)
        post :create, signup_params
      end

      context "redirection" do
        it "should redirect_to site defaults url" do
          SiteDefault.stub(:get).with('public_signup.form.success_url') { "success_url" }
          post :create, signup_params
          response.should redirect_to("success_url")
        end

        it "should redirect to default en url when no site default" do
          post :create, signup_params
          response.should redirect_to(thank_you_public_signups_path(locale: 'en'))
        end

        context "site de" do
          before do
            Site.stub(name: 'de')
          end

          %w(en de).each do |lang|
            it "should redirect to #{lang} url" do
              signup_params[:public_signup][:registration_attributes][:lang] = lang
              post :create, signup_params
              response.should redirect_to(thank_you_public_signups_path(locale: lang))
            end
          end
        end
      end

      context "duplicate signups" do

        it "should not add the same angel to the same workshop" do
          post :create, signup_params
          expect(Registration.count).to eql(1)
          post :create, signup_params
          ps = assigns[:public_signup]
          expect(ps.errors.messages.keys).to include(:"registration.event_id")
        end
      end

    end

    context "an invalid signup" do
      let(:signup_params) do
        {
            public_signup: attributes_for(:public_signup).merge(
                registration_attributes: {event_id: event.id})
        }
      end

      before do
        Site.stub(name: 'de')
      end

      it "should render new" do
        post :create, signup_params
        response.should render_template('new')
      end

      it "should not send notification email" do
        PublicSignup.any_instance.should_not_receive(:send_email)
        post :create, signup_params
      end

      context "language of messages" do
        let(:first_name) { assigns[:public_signup].errors.messages[:'registration.first_name'] }
        before do
          signup_params[:public_signup][:registration_attributes][:lang] = lang
          post :create, signup_params
        end
        context "en" do
          let(:lang) { 'en' }
          it { expect(first_name).to eq(["can't be blank"]) }
        end
        context "de" do
          let(:lang) { 'de' }
          it { expect(first_name).to eq(["muss ausgefüllt werden"]) }
        end
      end
    end
  end
end
