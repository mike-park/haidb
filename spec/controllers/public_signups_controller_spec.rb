# -*- coding: utf-8 -*-
require 'spec_helper'

describe PublicSignupsController do
  context "site specific switching" do
    render_views
    
    it "should render the correct form and layout" do
      Site::NAMES.each do |name|
        Site.stub(:name).and_return(name)
        basedir = "public_signups/#{name}"
        # no top level new template, only in subdirectory. 
        [lambda {get :new}, lambda {post :create}].each do |action|
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
    it "should create public_signup object" do
      post :create
      assigns[:public_signup].should be
    end
    
    it "should have default values" do
      I18n.locale = :en
      post :create
      ps = assigns[:public_signup]
      ps.registration.role.should == Registration::PARTICIPANT
      ps.registration.should_not be_approved
      ps.registration.angel.lang.should == 'en'
    end

    context "a valid signup" do
      let(:public_signup) {  mock_model(PublicSignup).as_null_object }
      before(:each) do
        public_signup.stub(:save).and_return(true)
        PublicSignup.stub(:new).and_return(public_signup)
      end

      it "should redirect_to site specific url" do
        Notifier.stub(:public_signup_received).and_return(double("email").as_null_object)
        post :create
        response.should redirect_to(Site.thankyou_url)
      end

      it "should send notification email" do
        notifier = mock(Notifier)
        notifier.stub(:deliver)
        Notifier.should_receive(:public_signup_received).with(public_signup).and_return(notifier)
        post :create
      end
    end

    context "an invalid signup" do
      it "should render new" do
        post :create
        response.should render_template('new')
      end

      it "should not send notification email" do
        notifier = mock(Notifier)
        notifier.stub(:deliver)
        Notifier.should_not_receive(:public_signup_received)
        post :create
      end

      context "language of messages" do
        it "should have English errors" do
          I18n.locale = :en
          post :create
          invalid_public_signup = assigns[:public_signup]
          invalid_public_signup.errors.messages.should == {
            :"registration.angel.first_name"=>["can't be blank"],
            :"registration.angel.last_name"=>["can't be blank"],
            :"registration.angel.email"=>["can't be blank"],
            :"registration.angel.gender"=>["must be selected"],
            :"registration.event"=>["must be selected"],
            :terms_and_conditions=>["must be accepted"]
          }
        end

        it "should have German errors" do
          I18n.locale = :de
          post :create
          invalid_public_signup = assigns[:public_signup]
          invalid_public_signup.errors.messages.should == {
            :"registration.angel.first_name"=>["muss ausgefüllt werden"],
            :"registration.angel.last_name"=>["muss ausgefüllt werden"],
            :"registration.angel.email"=>["muss ausgefüllt werden"],
            :"registration.angel.gender"=>["muss ausgewählt werden"],
            :"registration.event"=>["muss ausgewählt werden"],
            :terms_and_conditions=>["muss akzeptiert werden"]
          }
        end
      end
    end
    
  end
  
end
