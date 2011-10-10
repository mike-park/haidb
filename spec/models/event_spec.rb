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

    context "language of messages" do
      it "should have English errors" do
        I18n.locale = :en
        invalid_event = Event.create
        invalid_event.errors.messages.should == {
          :display_name=>["can't be blank"],
          :category=>["can't be blank", "is not included in the list"],
          :start_date=>["can't be blank"]}
      end

      it "should have German errors" do
        I18n.locale = :de
        invalid_event = Event.create
        invalid_event.errors.messages.should == {
          :display_name=>["muss ausgefüllt werden"],
          :category=>["muss ausgefüllt werden", "ist kein gültiger Wert"],
          :start_date=>["muss ausgefüllt werden"]}
      end
    end
  end

  context "scopes" do
    before(:all) do
      @e1 = Factory.create(:event, :start_date => Date.new(2010, 12, 1))
      @e2 = Factory.create(:event, :start_date => Date.tomorrow)
      @e3 = Factory.create(:event, :start_date => Date.new(2009, 6, 29))
      @e4 = Factory.create(:event, :start_date => Date.new(2020, 12, 31))
    end
    after(:all) do
      Event.delete_all
    end
    
    it "should order by oldest last" do
      all = Event.with_oldest_last.all
      all.should == [@e4, @e2, @e1, @e3]
    end

    it "should have only future events in order as they will occur" do
      all = Event.upcoming.all
      all.should == [@e2, @e4]
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
  end
end
