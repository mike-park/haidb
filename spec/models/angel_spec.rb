# -*- coding: utf-8 -*-
require 'spec_helper'

describe Angel do
  context "#new validation" do
    [:last_name, :email].each do |name|
      it "is invalid without #{name}" do
        build(:angel, name => nil).should_not be_valid
      end
    end

    it "must have a valid gender" do
      build(:angel, gender: Registration::MALE).should be_valid
      build(:angel, gender: Registration::FEMALE).should be_valid
      build(:angel, gender: 'Other').should_not be_valid
      build(:angel, gender: '').should_not be_valid
      build(:angel, gender: nil).should be_valid
    end

    context "language of messages" do

      context "en" do
        before(:each) { I18n.locale = :en }

        it "should have English errors" do
          invalid_angel = Angel.create
          invalid_angel.errors.messages.should == {
              :last_name => ["can't be blank"],
              :email => ["can't be blank"]
          }
        end
      end

      context "de" do
        before(:each) { I18n.locale = :de }

        it "should have German errors" do
          invalid_angel = Angel.create
          invalid_angel.errors.messages.should == {
              :last_name => ["muss ausgefüllt werden"],
              :email => ["muss ausgefüllt werden"]
          }
        end
      end
    end
  end

  context "helpers when valid" do
    let(:angel) { FactoryGirl.create(:full_angel,
                                     :first_name => '   Mike   ',
                                     :last_name => '  Park   	',
                                     :email => ' MikeP@Quake.Net  ')
    }

    it "should have a display_name" do
      angel.display_name.should == "Park, Mike - Berlin"
    end

    it "should have a full_name" do
      angel.full_name.should == "Mike Park"
    end

    it "should have lowercase email" do
      angel.email.should == 'mikep@quake.net'
    end

    it "should have a full_address" do
      angel.send(:full_address).should == "Somewhere 140, 12345, Berlin, DE"
    end
  end

  context "add_to" do
    let(:registration) { FactoryGirl.create(:registration, gender: Registration::MALE) }
    it "should create a new angel" do
      Angel.count.should == 0
      Angel.add_to(registration)
      Angel.count.should == 1
    end

    context "assign existing angel" do
      let(:angel) { build(:angel, registration.attributes.slice(*Angel::REGISTRATION_MATCH_FIELDS)) }
      it "should assign existing angel" do
        angel.save!
        Angel.count.should == 1
        Angel.add_to(registration)
        Angel.count.should == 1
        expect(registration.angel_id).to eq(angel.id)
      end

      Angel::REGISTRATION_MATCH_FIELDS.each do |field|
        it "should not assign existing angel when #{field} is different" do
          angel.send("#{field}=", Registration::FEMALE)
          angel.save!
          Angel.count.should == 1
          Angel.add_to(registration)
          Angel.count.should == 2
          expect(registration.angel_id).to_not eq(angel.id)
        end
      end
    end
  end

  context "scopes" do
    it "should order by_last_name" do
      z = FactoryGirl.create(:angel, :last_name => 'Zoo')
      b = FactoryGirl.create(:angel, :last_name => 'Bird')
      a = FactoryGirl.create(:angel, :last_name => 'Animal')
      all = Angel.by_last_name.all
      all.should == [a, b, z]
    end
  end

  context "registrations" do
    it "should assign angel_id to added registrations" do
      angel = FactoryGirl.create(:angel)
      angel.registrations << FactoryGirl.build(:registration, :angel => nil)
      angel.save
      angel.registrations.count.should == 1
    end
  end


  context "highest level" do
    it "should match the highest completed level" do
      angel = FactoryGirl.create(:angel)
      other_angel = FactoryGirl.create(:angel)
      event1 = FactoryGirl.create(:event1)
      event3 = FactoryGirl.create(:event3)
      event5 = FactoryGirl.create(:event5)
      FactoryGirl.create(:registration,
                         :angel => angel,
                         :event => event3,
                         :completed => true)
      FactoryGirl.create(:registration,
                         :angel => angel,
                         :event => event1,
                         :completed => true)
      FactoryGirl.create(:registration,
                         :angel => angel,
                         :event => event5,
                         :completed => false)
      FactoryGirl.create(:registration,
                         :angel => other_angel,
                         :event => event5,
                         :completed => true)

      angel.highest_level.should == 3
      Angel.find(angel.id).highest_level.should == 3

      other_angel.highest_level.should == 5
      Angel.find(other_angel.id).highest_level.should == 5
    end
  end

  context "record counts" do
    it "should not delete registrations" do
      angel = FactoryGirl.create(:angel)
      registration = FactoryGirl.create(:registration, :angel => angel)
      Angel.should have(1).record
      Registration.should have(1).record
      expect(registration.angel).to eql(angel)

      angel.destroy

      Angel.should have(:no).records
      Registration.should have(1).records
      registration = Registration.first
      expect(registration.angel_id).to be_nil
    end
  end

  context "with duplicates" do
    let(:person) { {first_name: 'mike', last_name: 'park', email: 'a@example.com'} }
    let(:angel1) { FactoryGirl.create(:angel, person.merge(:notes => 1, :home_phone => 'something')) }
    let(:angel2) { FactoryGirl.create(:angel, person.merge(:notes => 2, :home_phone => nil)) }
    let(:l1) { FactoryGirl.create(:event1) }
    let(:l2) { FactoryGirl.create(:event2) }
    let(:l3) { FactoryGirl.create(:event3) }
    let(:l5) { FactoryGirl.create(:event5) }
    before(:each) do
      FactoryGirl.create(:registration, :event => l1, :angel => angel1, :completed => true)
      FactoryGirl.create(:registration, :event => l3, :angel => angel1, :completed => true)
      FactoryGirl.create(:registration, :event => l2, :angel => angel2, :completed => true)
      FactoryGirl.create(:registration, :event => l5, :angel => angel2, :completed => true)
    end

    it { Angel.count.should == 2 }
    it { Angel.find(1).notes.should == '1' }
    it { Angel.find(1).home_phone.should == 'something' }
    it { Angel.find(2).notes.should == '2' }
    it { Angel.find(2).home_phone.should_not be }
    it { Event.count.should == 4 }
    it { Registration.count.should == 4 }

    context "should merged into angel1" do
      #before(:each) do
      #  ActiveRecord::Base.logger = Logger.new(STDOUT)
      #  ActiveRecord::Base.clear_active_connections!
      #end

      it "from one other angel" do
        expect(Angel.merge_and_delete_duplicates_of(angel2)).to be_true
      end

      context "with changes of" do
        before(:each) do
          Angel.merge_and_delete_duplicates_of(angel2)
          angel1.reload
        end

        it { Angel.count.should == 1 }
        it { Angel.find(1).notes.should == '2' }
        it { Angel.find(1).home_phone.should_not be }
        it { Angel.find_by_id(2).should_not be }
        it { Event.count.should == 4 }
        it { Registration.count.should == 4 }
        it { angel1.registrations.count.should == 4 }
        it { angel1.highest_level.should == 5 }

      end
    end
  end
end
