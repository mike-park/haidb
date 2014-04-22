# -*- coding: utf-8 -*-
require 'spec_helper'

describe Event do
  context "#new validation" do

    it "is valid with min attributes" do
      valid_event = FactoryGirl.create(:event)
      valid_event.should be_valid
    end

    it "is valid with all attributes" do
      valid_event = FactoryGirl.create(:full_event)
      valid_event.should be_valid
    end

    it "is invalid without fields" do
      [:display_name, :category, :start_date].each do |field|
        in_valid_event = FactoryGirl.build(:event, field => nil)
        in_valid_event.should_not be_valid
      end
    end

    it "is invalid with random category" do
      in_valid_event = FactoryGirl.build(:event, :category => 'Random')
      in_valid_event.should_not be_valid
    end

    it "is valid with each category" do
      Event::CATEGORIES.each do |cat|
        valid_event = FactoryGirl.build(:event, :category => cat)
        valid_event.should be_valid
      end
    end

    it "accepts_nested_attributes for event_emails" do
      event = Event.new(FactoryGirl.attributes_for(:event).merge(event_emails_attributes: [FactoryGirl.attributes_for(:event_email)]))
      event.should be_valid
    end

    context "language of messages" do
      context "en" do
        before(:each) { I18n.locale = :en }
        it "should have English errors" do
          invalid_event = Event.create
          invalid_event.errors.messages.should == {
              :display_name => ["can't be blank"],
              :category => ["can't be blank", "is not included in the list"],
              :start_date => ["can't be blank"]}
        end
      end
      context "de" do
        before(:each) { I18n.locale = :de }
        it "should have German errors" do
          invalid_event = Event.create
          invalid_event.errors.messages.should == {
              :display_name => ["muss ausgefüllt werden"],
              :category => ["muss ausgefüllt werden", "ist kein gültiger Wert"],
              :start_date => ["muss ausgefüllt werden"]}
        end
      end
    end
  end

  context "scopes" do

    context "events" do
      before(:all) do
        @e1 = FactoryGirl.create(:event, :start_date => Date.new(2010, 12, 1))
        @e2 = FactoryGirl.create(:event, :start_date => Date.tomorrow)
        @e3 = FactoryGirl.create(:event, :start_date => Date.new(2009, 6, 29))
        @e4 = FactoryGirl.create(:event, :start_date => Date.new(2020, 12, 31))
        @e5 = FactoryGirl.create(:event, :start_date => Date.today - 5.days)
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

    context "completed_{registrations, angels}" do
      let(:event) { create(:event) }
      let(:registration) { create(:registration, event: event, completed: true, angel: create(:angel)) }

      before do
        create(:registration, event: event, angel: create(:angel))
      end

      it "should have a completed_registration" do
        expect(event.completed_registrations).to eq([registration])
      end

      it "should have a completed angel" do
        expect(event.completed_angels).to eq([registration.angel])
      end
    end
  end

  context "update_highest_level" do
    let(:event) { FactoryGirl.create(:event1, start_date: Date.today) }
    let(:angel) { double('angel', cache_highest_level: true) }

    before do
      event.stub(:angels).and_return([angel])
    end

    it "should call angel.cache_highest_level when event level changed" do
      angel.should_receive(:cache_highest_level)
      event.level = 2
      event.save
    end

    it "should not call angel.cache_highest_level when event level has not changed" do
      angel.should_not_receive(:cache_highest_level)
      event.start_date = Date.yesterday
      event.save
    end
  end

  context "record counts" do
    it "should also delete registrations" do
      event = FactoryGirl.create(:event)
      registration = FactoryGirl.create(:registration, :event => event)
      Event.should have(1).record
      Registration.should have(1).record

      event.destroy

      Event.should have(:no).records
      Registration.should have(:no).records
    end

    it "should delete event_emails" do
      event = FactoryGirl.create(:event)
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
    let(:locale) { 'en' }
    let(:event) { create(:event) }
    let(:email) { create(:email, locale: locale)}

    before do
      event.event_emails << create(:event_email, category: category, email_name: email.email_name)
    end

    it "should return email of matching email category & locale" do
      expect(event.email(category, locale)).to eq(email)
    end

    it "should return name of matching email category" do
      expect(event.email_name(category)).to eq(email.email_name.name)
    end
  end

  context "registration_codes" do
    context "with codes" do
      subject { FactoryGirl.create(:event, next_registration_code: '123') }

      it "should increment code" do
        subject.claim_registration_code.should == '123'
        subject.next_registration_code.should == '124'
      end

      it "should have registration codes" do
        subject.should have_registration_codes
      end
    end

    context "without codes" do
      it "should have no code" do
        ['', '  ', "\t\n ", nil].each do |code|
          event = FactoryGirl.create(:event, next_registration_code: code)
          ['claim', code, event.claim_registration_code].should == ['claim', code, nil]
          ['next', code, event.next_registration_code].should == ['next', code, nil]
          ['required?', code, event.has_registration_codes?].should == ['required?', code, false]
        end
      end
    end
  end

  context "cost_for" do
    let(:event) { FactoryGirl.build(:event, team_cost: 1, participant_cost: 2) }

    [[Registration::FACILITATOR, 0], [Registration::TEAM, 1], [Registration::PARTICIPANT, 2]].each do |role, cost|
      it "should return cost #{cost} for role #{role}" do
        [role, event.cost_for(role)].should == [role, cost]
      end
    end
  end

  context "registrations" do
    let(:event) { build(:event) }

    before do
      create(:registration, event: event, completed: false)
      create(:registration, event: event, completed: false)
      create(:registration, event: event, completed: true)
    end

    it "should have 1 completed registration" do
      expect(event.completed_registrations.count).to eq(1)
    end
  end
end
