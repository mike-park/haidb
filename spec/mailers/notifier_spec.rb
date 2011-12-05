# -*- coding: utf-8 -*-
require "spec_helper"

describe Notifier do
  context "original entry points" do
    let(:public_signup) { double("public_signup") }
    let(:registration) { double("registration") }
    before(:each) do
      public_signup.stub(:registration).and_return(registration)
    end

    it ".public_signup_received should delegate" do
       Notifier.any_instance.should_receive(:send_registration_email).with(EventEmail::SIGNUP, registration)
       Notifier.public_signup_received(public_signup)
     end
    it ".public_signup_waitlisted should delegate" do
       Notifier.any_instance.should_receive(:send_registration_email).with(EventEmail::PENDING, registration)
       Notifier.public_signup_waitlisted(public_signup)
     end
    it ".registration_confirmed should delegate" do
       Notifier.any_instance.should_receive(:send_registration_email).with(EventEmail::APPROVED, registration)
       Notifier.registration_confirmed(registration)
     end
  end

  context ".send_registration_email" do
    let(:category) { EventEmail::SIGNUP }
    let(:email) { Factory.build(:en_email,
                                subject: "subject {{person_name}} {{event_name}}",
                                body: "body {{person_name}} {{event_name}}") }
    let(:registration) { Factory.build(:full_registration) }
    let(:locale) { registration.angel.lang }
    subject { Notifier.send_registration_email(category, registration) }
    let(:sender) { Site.from_email }
    let(:site_name) { Site.name }
    before(:each) do
      registration.event.stub(:email).with(category, locale).and_return(email)
    end

    it "should use angel.lang as locale" do
      registration.angel.lang = 'xx'
      registration.event.should_receive(:email).with(category, 'xx')
      subject
    end

    its(:from) { should == [sender] }
    its(:to) { should == [registration.angel.email] }
    its(:bcc) { should == [sender, "#{site_name}-emails@t.quake.net"] }
    its(:subject) { should == "subject #{registration.full_name} #{registration.event_name}" }
    its(:encoded) { should match("body #{registration.full_name} #{registration.event_name}") }

    it "should deliver email" do
      ActionMailer::Base.deliveries.count.should == 0
      subject.deliver
      ActionMailer::Base.deliveries.count.should == 1
    end
  end
end
