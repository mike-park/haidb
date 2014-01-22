# -*- coding: utf-8 -*-
require "spec_helper"

describe Notifier do
  context "#registration_with_template" do
    let(:email) { Factory.build(:en_email,
                                subject: "subject {{person_name}} {{event_name}}",
                                body: "body {{person_name}} {{event_name}}") }
    let(:registration) { Factory.build(:full_registration) }
    subject { Notifier.registration_with_template(registration, email) }
    let(:sender) { 'a_person@example.com' }
    let(:site_name) { Site.name }

    before do
      SiteDefault.stub(:get).with('email.registrations.from_address').and_return(sender)
    end

    its(:from) { should == [sender] }
    its(:to) { should == [registration.angel.email] }
    its(:bcc) { should == [sender] }
    its(:subject) { should == "subject #{registration.full_name} #{registration.event_name}" }
    its(:encoded) { should match("body #{registration.full_name} #{registration.event_name}") }

    it "should deliver email" do
      ActionMailer::Base.deliveries.count.should == 0
      subject.deliver
      ActionMailer::Base.deliveries.count.should == 1
    end
  end
end
