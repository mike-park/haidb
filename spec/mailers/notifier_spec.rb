# -*- coding: utf-8 -*-
require 'spec_helper'

describe Notifier do
  let(:event) { FactoryGirl.build(:event, display_name: 'Event Name') }
  let(:registration) { FactoryGirl.build(:registration, first_name: 'Mike', last_name: 'Park',
                                         email: 'somewhere@example.com', event: event, cost: 1.23,
                                         registration_code: 'reg_code', event: event,
                                         iban: '123 456 789 ', bic: 'bic', bank_account_name: 'account name') }
  let(:email) { FactoryGirl.build(:en_email) }
  let(:options) { {} }
  subject { Notifier.registration_with_template(registration, email, options) }

  context 'mail headers' do
    let(:sender) { 'a_person@example.com' }
    before do
      SiteDefault.stub(:get).with('email.registrations.from_address').and_return(sender)
    end

    its(:from) { should == [sender] }
    its(:to) { should == [registration.email] }
    its(:bcc) { should == [sender] }
  end

  context 'override from and bcc' do
    let(:from) { 'haha@override.com' }
    let(:options) { {from: from} }

    its(:from) { should == [from] }
    its(:bcc) { should == [from] }
  end

  context 'delivery' do
    it 'should deliver email' do
      expect(ActionMailer::Base.deliveries.count).to eq(0)
      subject.deliver
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  context 'cost interpolation' do
    let(:email) { FactoryGirl.build(:en_email, subject: '{{cost}}', body: '{{cost}}') }
    [
        # site cost
        ['de', '1,23 €'],
        ['uk', '£1.23']
    ].each do |(site, cost)|
      context "site #{site}" do
        before do
          Site.stub(:name).and_return(site)
        end
        its(:subject) { should eq cost}
        its(:body) { should eq cost}
      end
    end
  end

  context 'iban interpolation' do
    let(:email) { FactoryGirl.build(:en_email, :subject => "{{iban}}", body: "{{iban}}") }
    its(:subject) { should match("#{registration.iban_blurred}") }
    its(:body) { should match("#{registration.iban_blurred}") }
  end

  context 'registration interpolation' do
    [[:person_name, :full_name],
     [:account_name, :bank_account_name],
     [:event_name, :event_name],
     [:registration_code, :registration_code],
     [:bic, :bic]
    ].each do |(liquid_name, name)|
      context "#{name} interpolation" do
        let(:email) { FactoryGirl.build(:en_email, :subject => "subject {{#{liquid_name}}}", body: "body {{#{liquid_name}}}") }
        its(:subject) { should match("subject #{registration.send(name)}") }
        its(:body) { should match("body #{registration.send(name)}") }
      end
    end
  end

  context 'option interpolation' do
    let(:foo) { 'foo' }
    let(:options) { {foo: foo} }
    let(:email) { FactoryGirl.build(:en_email, subject: '{{foo}}', body: '{{foo}}') }
    its(:subject) { should eq foo}
    its(:body) { should eq foo}
  end

  context 'empty bank account name' do
    let(:registration) { FactoryGirl.build(:registration, first_name: 'Mike', last_name: 'Park',
                                           bank_account_name: '') }
    let(:email) { FactoryGirl.build(:en_email, subject: '{{account_name}}', body: '{{account_name}}') }
    its(:subject) { should eq 'Mike Park'}
    its(:body) { should eq 'Mike Park'}
  end
end
