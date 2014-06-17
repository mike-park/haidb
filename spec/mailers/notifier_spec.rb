# -*- coding: utf-8 -*-
require "spec_helper"

describe Notifier do
  context "#registration_with_template" do
    let(:event) { FactoryGirl.build(:event, display_name: 'Event Name') }
    let(:registration) { FactoryGirl.build(:registration, first_name: 'Mike', last_name: 'Park',
                                           email: 'somewhere@example.com', event: event, cost: 1.23,
                                           registration_code: 'reg_code', event: event,
                                           iban: 'iban', bic: 'bic', bank_account_name: 'account name') }
    let(:sender) { 'a_person@example.com' }
    let(:interpolated_vars) { "{{person_name}} {{event_name}} {{registration_code}} {{iban}} {{bic}} {{account_name}} {{cost}}" }
    let(:interpolated_result) { "#{registration.full_name} #{event.display_name} #{registration.registration_code} #{registration.iban} #{registration.bic} #{registration.bank_account_name}" }
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
      it "should have #{site} cost subject" do
        Site.stub(:name).and_return(site)
        subject.subject.should match(subject_cost)
      end
      it "should have #{site} cost body" do
        Site.stub(:name).and_return(site)
        subject.encoded.should match(body_cost)
      end
    end

    its(:subject) { should match("subject #{interpolated_result}") }
    its(:encoded) { should match("body #{interpolated_result}") }

    it "should deliver email" do
      ActionMailer::Base.deliveries.count.should == 0
      subject.deliver
      ActionMailer::Base.deliveries.count.should == 1
    end

    context "with options" do
      let(:from) { 'haha@override.com' }
      subject { Notifier.registration_with_template(registration, email, from: from) }

      its(:from) { should == [from] }
      its(:bcc) { should == [from] }
    end
  end
end
