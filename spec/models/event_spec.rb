# -*- coding: utf-8 -*-
require 'spec_helper'

describe Event do
  context "#new validation" do

    it "is valid with min attributes" do
      valid_event = Factory.create(:event)
      valid_event.should be_valid
    end

    it "is valid with all attributes" do
      valid_event = Factory.create(:full_event)
      valid_event.should be_valid
    end

    it "is invalid without fields" do
      [:display_name, :category, :start_date].each do |field|
        in_valid_event = Factory.build(:event, field => nil)
        in_valid_event.should_not be_valid
      end
    end

    it "is invalid with random category" do
      in_valid_event = Factory.build(:event, :category => 'Random')
      in_valid_event.should_not be_valid
    end

    it "is valid with each category" do
      Event::CATEGORIES.each do |cat|
        valid_event = Factory.build(:event, :category => cat)
        valid_event.should be_valid
      end
    end

    it "accepts_nested_attributes for event_emails" do
      event = Event.new(Factory.attributes_for(:event).merge(event_emails_attributes: [Factory.attributes_for(:event_email)]))
      event.should be_valid
    end

    context "language of messages" do
      context "en" do
        before(:each) { I18n.locale = :en }
        it "should have English errors" do
          invalid_event = Event.create
          invalid_event.errors.messages.should == {
              :display_name=>["can't be blank"],
              :category=>["can't be blank", "is not included in the list"],
              :start_date=>["can't be blank"]}
        end
      end
      context "de" do
        before(:each) { I18n.locale = :de }
        it "should have German errors" do
          invalid_event = Event.create
          invalid_event.errors.messages.should == {
              :display_name=>["muss ausgefüllt werden"],
              :category=>["muss ausgefüllt werden", "ist kein gültiger Wert"],
              :start_date=>["muss ausgefüllt werden"]}
        end
      end
    end
  end

  context "scopes" do
    before(:all) do
      @e1 = Factory.create(:event, :start_date => Date.new(2010, 12, 1))
      @e2 = Factory.create(:event, :start_date => Date.tomorrow)
      @e3 = Factory.create(:event, :start_date => Date.new(2009, 6, 29))
      @e4 = Factory.create(:event, :start_date => Date.new(2020, 12, 31))
      @e5 = Factory.create(:event, :start_date => Date.today - 5.days)
    end
    after(:all) do
      Event.delete_all
    end

    it "should order by oldest last" do
      all = Event.with_oldest_last.all
      all.should == [@e4, @e2, @e5, @e1, @e3]
    end

    it "should have only future events in order as they will occur" do
      all = Event.upcoming.all
      all.should == [@e2, @e4]
    end

    it "should have only 3 current events" do
      Event.current.all.should == [@e5, @e2, @e4]
    end
  end

  context "observer" do
    it "should call angel cache_highest_level when event level changed" do
      event = Factory.create(:event1)
      angel = mock('angel')
      angel.stub(:cache_highest_level)
      event.stub(:angels).and_return([angel])

      angel.should_receive(:cache_highest_level)

      event.level = 2
      event.save
    end
  end

  context "record counts" do
    it "should also delete registrations" do
      event = Factory.create(:event)
      registration = Factory.create(:registration, :event => event)
      Event.should have(1).record
      Registration.should have(1).record

      event.destroy

      Event.should have(:no).records
      Registration.should have(:no).records
    end

    it "should delete event_emails" do
      event = Factory.create(:event)
      event.event_emails.build(category: EventEmail::CATEGORIES.first)
      event.event_emails.build(category: EventEmail::CATEGORIES.last)
      event.save
      Event.should have(1).record
      EventEmail.should have(2).records

      event.destroy

      Event.should have(:no).records
      EventEmail.should have(:no).records
    end
  end

  context "emails" do
    let(:category) { EventEmail::CATEGORIES.first }
    let(:event_email) { double("event_email") }
    subject { Factory.create(:event) }

    before(:each) do
      subject.event_emails.stub(:find_by_category).with(category).and_return(event_email)
    end

    it "should return email of matching email category & locale" do
      event_email.should_receive(:email).with('en').and_return('found')
      subject.email(category, 'en').should == 'found'
    end
    it "should return name of matching email category" do
      event_email.should_receive(:name).and_return('name')
      subject.email_name(category).should == 'name'
    end
  end
end



# == Schema Information
#
# Table name: events
#
#  id           :integer         not null, primary key
#  display_name :string(255)     not null
#  category     :string(255)     not null
#  level        :integer         default(0)
#  start_date   :date            not null
#  created_at   :datetime
#  updated_at   :datetime
#

