# -*- coding: utf-8 -*-
require 'spec_helper'

describe Registration do
  context "#new validation" do
    it "should have default values" do
      default_registration = Registration.new
      default_registration.role.should == Registration::PARTICIPANT
      default_registration.payment_method.should_not be
      default_registration.should_not be_approved
    end

    it "is valid with min attributes" do
      valid_registration = FactoryGirl.create(:registration)
      valid_registration.should be_valid
    end

    it "is valid with all attributes" do
      valid_registration = FactoryGirl.create(:full_registration)
      valid_registration.should be_valid
    end

    it "is invalid without fields" do
      [:role, :angel, :event].each do |field|
        in_valid_registration = FactoryGirl.build(:registration, field => nil)
        in_valid_registration.should_not be_valid
      end
    end

    it "is invalid with random list item" do
      [:role, :lift, :sunday_choice].each do |field|
        in_valid_registration = FactoryGirl.build(:registration, field => 'Random')
        in_valid_registration.should_not be_valid
      end
    end

    it "is valid with each item in each list" do
      lists = {
          :role => Registration::ROLES,
          :lift => Registration::LIFTS,
          :sunday_choice => Registration::SUNDAY_CHOICES
      }
      lists.each do |field, values|
        values.each do |value|
          valid_registration = FactoryGirl.build(:registration, field => value)
          valid_registration.valid?
          valid_registration.errors.messages.should == {}
          valid_registration.should be_valid
          valid_registration.send(field).should == value
        end
      end
    end

    it "should be valid without payment fields when not type PAY_DEBT" do
      methods = Registration::PAYMENT_METHODS - [Registration::PAY_DEBT]
      methods.each do |method|
        valid_registration = FactoryGirl.build(:registration, :payment_method => method)
        valid_registration.valid?
        valid_registration.errors.messages.should == {}
        valid_registration.should be_valid
        valid_registration.payment_method.should == method
      end
    end

    it "should be invalid without payment fields when type PAY_DEBT" do
      in_valid_registration = FactoryGirl.build(:registration, :payment_method => Registration::PAY_DEBT)
      in_valid_registration.should_not be_valid
    end

    it "should be invalid to register the same angel for the same workshop twice" do
      first_registration = FactoryGirl.create(:registration)
      second_registration = FactoryGirl.build(:registration,
                                          :angel => first_registration.angel,
                                          :event => first_registration.event)
      second_registration.should_not be_valid
      second_registration.errors.messages.should == {
          :angel_id=>["already registered for this event"]
      }
    end

    it "should accept nested attributes for angel" do
      angel = FactoryGirl.build(:angel)
      registration = Registration.new(:angel_attributes => FactoryGirl.attributes_for(:angel))
      registration.angel.inspect.should == angel.inspect
    end

    it "should accept pre-existing angel for new registration" do
      angel = FactoryGirl.create(:angel)
      registration = FactoryGirl.build(:registration, :angel => nil, :angel_id => angel.id)
      registration.should be_valid
    end

    it "should accept pre-existing event for new registration" do
      event = FactoryGirl.create(:event)
      registration = FactoryGirl.build(:registration, :event => nil, :event_id => event.id)
      registration.valid?
      registration.errors.messages.should == {}
      registration.should be_valid
    end

    context "language of messages" do
      before do
        Site.stub(:name).and_return('de')
      end

      context "en" do
        before(:each) { I18n.locale = :en }
        it "should have English errors" do
          invalid_registration = Registration.create
          invalid_registration.errors.messages.should == {
              :angel=>["can't be blank"],
              :event=>["must be selected"]
          }
        end
      end

      context "de" do
        before(:each) { I18n.locale = :de }
        it "should have German errors" do
          invalid_registration = Registration.create
          invalid_registration.errors.messages.should == {
              :angel=>["muss ausgefüllt werden"],
              :event=>["muss ausgewählt werden"]
          }
        end
      end
    end
  end

  context "delegation" do
    it "should delegate these fields" do
      registration = FactoryGirl.build(:full_registration)
      event = registration.event
      angel = registration.angel
      registration.level.should == event.level
      registration.event_name.should == event.display_name
      registration.full_name.should == angel.full_name
      registration.gender.should == angel.gender
      registration.lang.should == angel.lang
      registration.email.should == angel.email
    end
  end

  context "highest level" do
    it "should return the highest completed level" do
      e1 = FactoryGirl.build(:event1)
      e3 = FactoryGirl.build(:event3)
      e5 = FactoryGirl.build(:event5)
      r1 = FactoryGirl.create(:registration, :event => e1, :completed => true)
      r2 = FactoryGirl.create(:registration, :event => e3, :completed => true)
      r3 = FactoryGirl.create(:registration, :event => e5, :completed => false)
      Registration.highest_completed_level.should == 3
    end

    it "should return 0 if no levels are completed" do
      r1 = FactoryGirl.create(:registration)
      Registration.highest_completed_level.should == 0
    end
  end

  context "registration code" do
    it "should save a registration code" do
      event = FactoryGirl.create(:event, next_registration_code: '123')
      registration = FactoryGirl.create(:registration, event: event, approved: true)
      registration.registration_code.should == '123'
    end

    it "should not save a registration code" do
      event = FactoryGirl.create(:event, next_registration_code: '123')
      registration = FactoryGirl.create(:registration, event: event, approved: false)
      registration.registration_code.should_not be
    end

    it "should not change an existing code" do
      event = FactoryGirl.create(:event, next_registration_code: '123')
      registration = FactoryGirl.create(:registration, event: event, approved: true, registration_code: '999')
      registration.registration_code.should == '999'
    end

    it "should have no registration code" do
      event = FactoryGirl.create(:event, next_registration_code: nil)
      registration = FactoryGirl.create(:registration, event: event, approved: true)
      registration.registration_code.should_not be
    end
  end

  context "approve!" do
    let(:event) { FactoryGirl.create(:event, team_cost: 1, participant_cost: 2) }
    let(:registration) { FactoryGirl.build(:registration, role: Registration::FACILITATOR, event: event) }

    [[Registration::FACILITATOR, 0], [Registration::TEAM, 1], [Registration::PARTICIPANT, 2]].each do |role, cost|
      it "should set a #{role} cost to #{cost}" do
        registration.role = role
        registration.approve!
        [role, registration.cost].should == [role, cost]
      end
    end
  end

  context "scopes" do
    it "should return them in first name order" do
      r1 = FactoryGirl.create(:registration, :angel => FactoryGirl.build(:angel, :first_name => 'Z'))
      r2 = FactoryGirl.create(:registration, :angel => FactoryGirl.build(:angel, :first_name => 'A'))
      Registration.by_first_name.all.should == [r2, r1]
    end

    it "should return only approved registrations" do
      r1 = FactoryGirl.create(:registration, :approved => false)
      r2 = FactoryGirl.create(:registration, :approved => true)
      Registration.ok.all.should == [r2]
    end
    it "should return only pending registrations" do
      r1 = FactoryGirl.create(:registration, :approved => false)
      r2 = FactoryGirl.create(:registration, :approved => true)
      Registration.pending.all.should == [r1]
    end
    it "should return only approved team/participant/facilitator registrations" do
      r1 = FactoryGirl.create(:registration, :approved => false)
      t = FactoryGirl.create(:registration, :role => Registration::TEAM, :approved => true)
      p = FactoryGirl.create(:registration, :role => Registration::PARTICIPANT, :approved => true)
      f = FactoryGirl.create(:registration, :role => Registration::FACILITATOR, :approved => true)
      Registration.team.all.should == [t]
      Registration.facilitators.all.should == [f]
      Registration.participants.all.should == [p]
    end
  end

  context "observer" do
    it "should call angel cache_highest_level when registration saved" do
      registration = FactoryGirl.create(:registration)
      registration.angel.stub(:cache_highest_level)

      registration.angel.should_receive(:cache_highest_level)

      registration.save
    end

    it "should call angel cache_highest_level when registration deleted" do
      registration = FactoryGirl.create(:registration)
      registration.angel.stub(:cache_highest_level)

      registration.angel.should_receive(:cache_highest_level)

      registration.destroy
    end
  end

  context "record counts" do
    it "should increase when adding a registration" do
      registration = FactoryGirl.create(:registration)
      Angel.should have(1).record
      Registration.should have(1).record
      Event.should have(1).record
    end
    it "should destroy public_signup when registration is destroyed" do
      public_signup = FactoryGirl.create(:public_signup)
      PublicSignup.should have(1).record
      Registration.should have(1).record

      public_signup.registration.destroy

      Registration.should have(:no).records
      PublicSignup.should have(:no).records
    end
  end

  context "emails" do
    let(:registration) { FactoryGirl.create(:registration) }
    context "lang" do
      it "should return the angel lang" do
        registration.lang.should == registration.angel.lang
      end
      it "should default to en lang" do
        registration.angel.lang = nil
        registration.lang.should == 'en'
      end
    end

    it "should send registration email" do
      email_template = double('email_template')
      registration.event.should_receive(:email).with(EventEmail::SIGNUP, registration.lang).and_return(email_template)
      email_msg = double('email_msg').as_null_object
      Notifier.should_receive(:registration_with_template).with(registration, email_template).and_return(email_msg)
      registration.send_email(EventEmail::SIGNUP)
    end
  end

end
