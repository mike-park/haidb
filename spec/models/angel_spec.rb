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

    it "should have active_membership" do
      angel = create(:angel)
      membership = create(:membership, angel: angel, retired_on: nil)
      expect(angel.active_membership).to eq(membership)
    end

    context "duplicates_of" do
      let(:angel) { create(:angel) }

      before do
        angel.dup.save!
      end

      it "should find duplicates" do
        expect(Angel.duplicates_of(angel).count).to eq(2)
      end

      [:first_name, :last_name, :email].each do |field|
        it "should find even with different case of #{field}" do
          angel.update_attribute(field, angel.send(field).upcase)
          expect(Angel.duplicates_of(angel).count).to eq(2)
        end
      end
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

    it "should not destroy users" do
      user = create(:user, angel: create(:angel))
      expect(user.angel).to be
      user.angel.destroy
      user.reload
      expect(user.angel).to_not be
    end
  end


  context "merge_and_delete_duplicates" do
    let(:person) { build(:angel, gender: Registration::MALE).attributes.slice(*Angel::REGISTRATION_MATCH_FIELDS) }
    before do
      @angels = create_pair(:angel, person)
      create_list(:angel, 2)
    end

    it { expect(Angel.count).to eq(4) }

    it "should merge angels" do
      expect { Angel.merge_and_delete_duplicates }.to change(Angel, :count).by(-1)
    end

    Angel::REGISTRATION_MATCH_FIELDS.each do |field|
      it "should not merge when #{field} is different" do
        @angels[0].update_attribute(field, Registration::FEMALE)
        expect { Angel.merge_and_delete_duplicates }.to change(Angel, :count).by(0)
      end
    end
  end
end
