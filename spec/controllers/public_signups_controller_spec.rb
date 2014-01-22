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
        [lambda { get :new }, lambda { post :create }].each do |action|
          action.call
          assigns[:basedir].should == basedir
          response.should render_template("#{basedir}/new", "layouts/#{name}_site")
        end
      end
    end
  end

  describe "GET new" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should create public_signup object (with registration & angel)" do
      get :new
      assigns[:public_signup].should be
      assigns[:public_signup].registration.should be
      assigns[:public_signup].registration.angel.should be
    end
  end

  describe "POST create" do
    before(:each) { I18n.locale = :en }

    it "should create public_signup object" do
      post :create
      assigns[:public_signup].should be
    end

    it "should have default values" do
      post :create
      ps = assigns[:public_signup]
      ps.registration.role.should == Registration::PARTICIPANT
      ps.registration.should_not be_approved
      ps.registration.angel.lang.should == 'en'
    end

    context "a valid signup" do
      let(:public_signup) { double("PublicSignup").as_null_object }
      before(:each) do
        public_signup.stub(:save).and_return(true)
        PublicSignup.stub(:new).and_return(public_signup)
      end

      it "should redirect_to site specific url" do
        success_url = 'https://somewhere.over.the.mountain/'
        SiteDefault.create!(description: 'desc',
                            translation_key_attributes: {
                                key: 'public_signup.form.success_url',
                                translations_attributes: [
                                    {locale: 'en', text: success_url}
                                ]})
        post :create
        response.should redirect_to(success_url)
        SiteDefault.destroy_all
      end

      it "should redirect to local url if no specific url exists" do
        post :create, template_version: '99'
        response.should redirect_to(public_signup_url(0, template_version: '99'))
      end

      it "should send notification email" do
        public_signup.should_receive(:send_email).with(EventEmail::SIGNUP)
        post :create
      end
    end

    context "an invalid signup" do
      it "should render new" do
        post :create
        response.should render_template('new')
      end

      it "should not send notification email" do
        post :create
        ActionMailer::Base.deliveries.count.should == 0
      end

      context "language of messages" do
        context "en" do
          before(:each) { I18n.locale = :en }
          it "should have English errors" do
            post :create
            invalid_public_signup = assigns[:public_signup]
            invalid_public_signup.errors.messages.should == {
                :"registration.angel.first_name" => ["can't be blank"],
                :"registration.angel.last_name" => ["can't be blank"],
                :"registration.angel.email" => ["can't be blank"],
                :"registration.angel.gender" => ["must be selected"],
                :"registration.event" => ["must be selected"],
                :terms_and_conditions => ["must be accepted"]
            }
          end
        end
        context "de" do
          before(:each) { I18n.locale = :de }
          it "should have German errors" do
            post :create
            invalid_public_signup = assigns[:public_signup]
            invalid_public_signup.errors.messages.should == {
                :"registration.angel.first_name" => ["muss ausgefüllt werden"],
                :"registration.angel.last_name" => ["muss ausgefüllt werden"],
                :"registration.angel.email" => ["muss ausgefüllt werden"],
                :"registration.angel.gender" => ["muss ausgewählt werden"],
                :"registration.event" => ["muss ausgewählt werden"],
                :terms_and_conditions => ["muss akzeptiert werden"]
            }
          end
        end
      end
    end

  end

end
