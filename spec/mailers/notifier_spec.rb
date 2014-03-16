# -*- coding: utf-8 -*-
require "spec_helper"

describe Notifier do
  context "#registration_with_template" do
    let(:event) { FactoryGirl.build(:event, display_name: 'Event Name') }
    let(:registration) { FactoryGirl.build(:registration, first_name: 'Mike', last_name: 'Park',
                                           email: 'somewhere@example.com', event: event, cost: 1.23,
                                           registration_code: 'reg_code', event: event) }
    let(:sender) { 'a_person@example.com' }
    let(:interpolated_vars) { "{{person_name}} {{event_name}} {{registration_code}} {{cost}}" }
    let(:email) { FactoryGirl.build(:en_email,
                                    subject: "subject #{interpolated_vars}",
                                    body: "body #{interpolated_vars}") }

    subject { Notifier.registration_with_template(registration, email) }

    before do
      SiteDefault.stub(:get).with('email.registrations.from_address').and_return(sender)
    end

    its(:from) { should == [sender] }
    its(:to) { should == [registration.email] }
    its(:bcc) { should == [sender] }
    [
        ['de', '1,23 €', '1,23 =E2=82=AC='],
        ['uk', '£1.23', '=C2=A31.23=']
    ].each do |(site, subject_cost, body_cost)|
      it "should have #{site} subject" do
        Site.stub(:name).and_return(site)
        subject.subject.should == "subject #{registration.full_name} #{event.display_name} #{registration.registration_code} #{subject_cost}"
      end
      it "should have #{site} body" do
        Site.stub(:name).and_return(site)
        subject.encoded.should match("body #{registration.full_name} #{event.display_name} #{registration.registration_code} #{body_cost}")
      end
    end


    it "should deliver email" do
      ActionMailer::Base.deliveries.count.should == 0
      subject.deliver
      ActionMailer::Base.deliveries.count.should == 1
    end
  end
end
