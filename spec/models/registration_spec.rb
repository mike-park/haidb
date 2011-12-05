# -*- coding: utf-8 -*-
require 'spec_helper'

describe Registration do
  context "#new validation" do
    it "should have default values" do
      default_registration = Registration.new
      default_registration.role.should == Registration::PARTICIPANT
      default_registration.payment_method.should == Registration::DIRECT
      default_registration.should_not be_approved
    end
    
    it "is valid with min attributes" do
      valid_registration = Factory.create(:registration)
      valid_registration.should be_valid
    end

    it "is valid with all attributes" do
      valid_registration = Factory.create(:full_registration)
      valid_registration.should be_valid
    end

    it "is invalid without fields" do
      [:role, :angel, :event, :payment_method].each do |field|
        in_valid_registration = Factory.build(:registration, field => nil)
        in_valid_registration.should_not be_valid
      end
    end

    it "is invalid with random list item" do
      [:role, :lift, :payment_method, :sunday_choice].each do |field|
        in_valid_registration = Factory.build(:registration, field => 'Random')
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
          valid_registration = Factory.build(:registration, field => value)
          valid_registration.valid?
          valid_registration.errors.messages.should == {}
          valid_registration.should be_valid
          valid_registration.send(field).should == value
        end
      end
    end

    it "should be valid without payment fields when not type internet" do
      methods = Registration::PAYMENT_METHODS - [Registration::INTERNET]
      methods.each do |method|
        valid_registration = Factory.build(:registration, :payment_method => method)
        valid_registration.valid?
        valid_registration.errors.messages.should == {}
        valid_registration.should be_valid
        valid_registration.payment_method.should == method
      end
    end
    
    it "should be invalid without payment fields when type internet" do
      in_valid_registration = Factory.build(:registration, :payment_method => Registration::INTERNET)
      in_valid_registration.should_not be_valid
    end

    it "should be invalid to register the same angel for the same workshop twice" do
      first_registration = Factory.create(:registration)
      second_registration = Factory.build(:registration,
                                          :angel => first_registration.angel,
                                          :event => first_registration.event)
      second_registration.should_not be_valid
      second_registration.errors.messages.should == {
        :angel_id=>["already registered for this event"]
      }
    end
    
    it "should accept nested attributes for angel" do
      angel = Factory.build(:angel)
      registration = Registration.new(:angel_attributes => Factory.attributes_for(:angel))
      registration.angel.inspect.should == angel.inspect
    end

    it "should accept pre-existing angel for new registration" do
      angel = Factory.create(:angel)
      registration = Factory.build(:registration, :angel => nil, :angel_id => angel.id)
      registration.should be_valid
    end

    it "should accept pre-existing event for new registration" do
      event = Factory.create(:event)
      registration = Factory.build(:registration, :event => nil, :event_id => event.id)
      registration.valid?
      registration.errors.messages.should == {}
      registration.should be_valid
    end

    context "language of messages" do
      it "should have English errors" do
        I18n.locale = :en
        invalid_registration = Registration.create
        invalid_registration.errors.messages.should == {
          :angel=>["can't be blank"],
          :event=>["must be selected"]
        }
      end

      it "should have German errors" do
        I18n.locale = :de
        invalid_registration = Registration.create
        invalid_registration.errors.messages.should == {
          :angel=>["muss ausgefüllt werden"],
          :event=>["muss ausgewählt werden"]
        }
      end
    end
  end

  context "delegation" do
    it "should delegate these fields" do
      registration = Factory.build(:full_registration)
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
      e1 = Factory.build(:event1)
      e3 = Factory.build(:event3)
      e5 = Factory.build(:event5)
      r1 = Factory.create(:registration, :event => e1, :completed => true)
      r2 = Factory.create(:registration, :event => e3, :completed => true)
      r3 = Factory.create(:registration, :event => e5, :completed => false)
      Registration.highest_completed_level.should == 3
    end

    it "should return 0 if no levels are completed" do
      r1 = Factory.create(:registration)
      Registration.highest_completed_level.should == 0
    end
    
  end
  
  
  context "scopes" do
    it "should return them in first name order" do
      r1 = Factory.create(:registration, :angel => Factory.build(:angel, :first_name => 'Z'))
      r2 = Factory.create(:registration, :angel => Factory.build(:angel, :first_name => 'A'))
      Registration.by_first_name.all.should == [r2, r1]
    end

    it "should return only approved registrations" do
      r1 = Factory.create(:registration, :approved => false)
      r2 = Factory.create(:registration, :approved => true)
      Registration.ok.all.should == [r2]
    end
    it "should return only pending registrations" do
      r1 = Factory.create(:registration, :approved => false)
      r2 = Factory.create(:registration, :approved => true)
      Registration.pending.all.should == [r1]
    end
    it "should return only approved team/participant/facilitator registrations" do
      r1 = Factory.create(:registration, :approved => false)
      t = Factory.create(:registration, :role => Registration::TEAM, :approved => true)
      p = Factory.create(:registration, :role => Registration::PARTICIPANT, :approved => true)
      f = Factory.create(:registration, :role => Registration::FACILITATOR, :approved => true)
      Registration.team.all.should == [t]
      Registration.facilitators.all.should == [f]
      Registration.participants.all.should == [p]
    end
  end

  context "observer" do
    it "should call angel cache_highest_level when registration saved" do
      registration = Factory.create(:registration)
      registration.angel.stub(:cache_highest_level)

      registration.angel.should_receive(:cache_highest_level)

      registration.save
    end

    it "should call angel cache_highest_level when registration deleted" do
      registration = Factory.create(:registration)
      registration.angel.stub(:cache_highest_level)

      registration.angel.should_receive(:cache_highest_level)

      registration.destroy
    end
  end

  context "record counts" do
    it "should increase when adding a registration" do
      registration = Factory.create(:registration)
      Angel.should have(1).record
      Registration.should have(1).record
      Event.should have(1).record
    end
    it "should destroy public_signup when registration is destroyed" do
      public_signup = Factory.create(:public_signup)
      PublicSignup.should have(1).record
      Registration.should have(1).record

      public_signup.registration.destroy

      Registration.should have(:no).records
      PublicSignup.should have(:no).records
    end
  end
end

# == Schema Information
#
# Table name: registrations
#
#  id                    :integer         primary key
#  angel_id              :integer         not null
#  event_id              :integer         not null
#  role                  :string(255)     default("Participant"), not null
#  special_diet          :boolean         default(FALSE)
#  backjack_rental       :boolean         default(FALSE)
#  sunday_stayover       :boolean         default(FALSE)
#  sunday_meal           :boolean         default(FALSE)
#  sunday_choice         :string(255)
#  lift                  :string(255)
#  payment_method        :string(255)     default("Direct")
#  bank_account_nr       :string(255)
#  bank_account_name     :string(255)
#  bank_name             :string(255)
#  bank_sort_code        :string(255)
#  notes                 :text
#  completed             :boolean         default(FALSE)
#  checked_in            :boolean         default(FALSE)
#  created_at            :timestamp
#  updated_at            :timestamp
#  public_signup_id      :integer
#  approved              :boolean         default(FALSE)
#  how_hear              :string(255)
#  previous_event        :string(255)
#  reg_fee_received      :boolean
#  clothing_conversation :boolean
#

