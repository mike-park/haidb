# -*- coding: utf-8 -*-
require "spec_helper"

describe Notifier do
  it "should have site defaults" do
    SiteDefault.all.count.should == 11
  end

  if Site.name == 'de'
    puts "Testing DE only"
    context "DE site" do
      before(:each) do
        ActionMailer::Base.deliveries.should be_empty
      end

      context "public signup" do
        let(:public_signup) { Factory.create(:public_signup) }
        
        context "independent of language" do
          let(:email) { Notifier.public_signup_received(public_signup) }
          let(:user_name) { 'registrations@haidb.info' }
          let(:bcc) { [user_name, 'de-emails@t.quake.net'] }
          
          context "headers & body contain" do
            it { email.bcc.should == bcc }
            it { email.from.first.should == user_name }
            it { email.to.first.should == public_signup.email }
            it { email.encoded.should match('Mikki Kitz') }
            it { email.encoded.should match(public_signup.full_name) }
          end
        end
        
        context "language :de" do
          let(:email) {
            I18n.locale = :de
            Notifier.public_signup_received(public_signup).deliver
          }
          it "should deliver email" do
            email
            ActionMailer::Base.deliveries.should_not be_empty
            ActionMailer::Base.deliveries.count.should == 1
          end
          it "should have subject line" do
            email.subject.should =~ /Vielen/i
          end
          it "should have body" do
            email.encoded.should =~ /Ihre Anmeldung/
          end
        end
      
        context "language :en" do
          let(:email) {
            I18n.locale = :en
            Notifier.public_signup_received(public_signup).deliver
          }
          it "should deliver email" do
            email
            ActionMailer::Base.deliveries.should_not be_empty
            ActionMailer::Base.deliveries.count.should == 1
          end
          it "should have subject line" do
            email.subject.should =~ /Thanks for/i
          end
          it "should have body" do
            email.encoded.should =~ /Dear #{public_signup.full_name}/
            email.encoded.should =~ /#{public_signup.event_name}/
          end
        end
      end

      context "registration confirmation" do
        let(:registration) { Factory.create(:registration) }

        context "independent of language" do
          let(:email) { Notifier.registration_confirmed(registration) }
          let(:user_name) { 'registrations@haidb.info' }
          let(:bcc) { [user_name, 'de-emails@t.quake.net'] }
          
          context "headers & body contain" do
            it { email.bcc.should == bcc }
            it { email.from.first.should == user_name }
            it { email.to.first.should == registration.email }
            it { email.encoded.should match('Mikki Kitz') }
            it { email.encoded.should match(registration.full_name) }
            it { email.encoded.should match(registration.event_name) }
          end
        end
        
        context "language :de" do
          let(:email) {
            I18n.locale = :de
            Notifier.registration_confirmed(registration).deliver
          }
          it "should deliver email" do
            email
            ActionMailer::Base.deliveries.should_not be_empty
            ActionMailer::Base.deliveries.count.should == 1
          end
          it "should have subject line" do
            email.subject.should match("Du bist für den Workshop #{registration.event_name} angemeldet")
          end
          it "should have body" do
            email.encoded.should match("du bist jetzt")
          end
        end
        
        context "language :en" do
          let(:email) {
            I18n.locale = :en
            Notifier.registration_confirmed(registration).deliver
          }
          it "should deliver email" do
            email
            ActionMailer::Base.deliveries.should_not be_empty
            ActionMailer::Base.deliveries.count.should == 1
          end
          it "should have subject line" do
            email.subject.should match("You are confirmed for #{registration.event_name}")
          end
          it "should have body" do
            email.encoded.should match("I hereby confirm")
          end
        end
      end
    end
  elsif Site.name == 'uk'
    puts "Testing UK only"
    context "UK site" do
      before(:each) do
        ActionMailer::Base.deliveries.should be_empty
      end

      context "public signup" do
        let(:public_signup) { Factory.create(:public_signup) }
        
        context "independent of language" do
          let(:email) { Notifier.public_signup_received(public_signup) }
          let(:user_name) { 'uk.registrations@haidb.info' }
          let(:bcc) { [user_name, 'uk-emails@t.quake.net'] }
          
          context "headers & body contain" do
            it { email.bcc.should == bcc }
            it { email.from.first.should == user_name }
            it { email.to.first.should == public_signup.email }
            it { email.encoded.should match('UK Producer') }
            it { email.encoded.should match(public_signup.full_name) }
          end
        end
        
        context "language :en" do
          let(:email) {
            I18n.locale = :en
            Notifier.public_signup_received(public_signup).deliver
          }
          it "should deliver email" do
            email
            ActionMailer::Base.deliveries.should_not be_empty
            ActionMailer::Base.deliveries.count.should == 1
          end
          it "should have subject line" do
            email.subject.should =~ /Thanks for/i
          end
          it "should have body" do
            email.encoded.should =~ /Dear #{public_signup.full_name}/
            email.encoded.should =~ /#{public_signup.event_name}/
          end
        end
      end

      context "registration confirmation" do
        let(:registration) { Factory.create(:registration) }
        
        context "independent of language" do
          let(:email) { Notifier.registration_confirmed(registration) }
          let(:user_name) { 'uk.registrations@haidb.info' }
          let(:bcc) { [user_name, 'uk-emails@t.quake.net'] }
          
          context "headers & body contain" do
            it { email.bcc.should == bcc }
            it { email.from.first.should == user_name }
            it { email.to.first.should == registration.email }
            it { email.encoded.should match('UK Producer') }
            it { email.encoded.should match(registration.full_name) }
            it { email.encoded.should match(registration.event_name) }
          end
        end
        
        context "language :en" do
          let(:email) {
            I18n.locale = :en
            Notifier.registration_confirmed(registration).deliver
          }
          it "should deliver email" do
            email
            ActionMailer::Base.deliveries.should_not be_empty
            ActionMailer::Base.deliveries.count.should == 1
          end
          it "should have subject line" do
            email.subject.should match("You are confirmed for #{registration.event_name}")
          end
          it "should have body" do
            email.encoded.should match("I hereby confirm")
          end
        end
      end
    end
  end
end
