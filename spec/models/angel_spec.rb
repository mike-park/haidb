# -*- coding: utf-8 -*-
require 'spec_helper'

# special notes: angel is autogeocoded before saving. should stub out this need unless
# actually testing geocoding

describe Angel do
  context "#new validation" do
    [:en, :de].each do |locale|
      context "language #{locale}" do
        before(:each) { I18n.locale = locale }
        it "should initialize lang with locale" do
          default_angel = Angel.new
          default_angel.lang.should == locale.to_s
        end
      end
    end

    context "locale lang en" do
      before(:each) { I18n.locale = :en }
      it "should not overwrite saved lang" do
        valid_angel = Factory.create(:angel, :lang => :de)
        valid_angel.lang.should == :de
        found_angel = Angel.find(valid_angel)
        found_angel.lang.should == 'de'
      end
    end

    it "is valid with min attributes" do
      valid_angel = Factory.create(:angel)
      valid_angel.should be_valid
    end

    it "is valid with all attributes" do
      valid_angel = Factory.create(:full_angel)
      valid_angel.should be_valid
    end

    it "is invalid without first_name" do
      in_valid_angel = Factory.build(:angel, :first_name => '')
      in_valid_angel.should_not be_valid
    end

    it "is invalid without last_name" do
      in_valid_angel = Factory.build(:angel, :last_name => '')
      in_valid_angel.should_not be_valid
    end

    it "is invalid without email" do
      in_valid_angel = Factory.build(:angel, :email => '')
      in_valid_angel.should_not be_valid
    end

    it "is invalid without gender" do
      in_valid_angel = Factory.build(:angel, :gender => '')
      in_valid_angel.should_not be_valid
    end

    it "is invalid with other build" do
      in_valid_angel = Factory.build(:angel, :gender => 'Other')
      in_valid_angel.should_not be_valid
    end

    it "is valid with each gender" do
      Angel::GENDERS.each do |gender|
        valid_angel = Factory.build(:angel, :gender => gender)
        valid_angel.should be_valid
      end
    end

    context "language of messages" do

      context "en" do
        before(:each) { I18n.locale = :en }

        it "should have English errors" do
          invalid_angel = Angel.create
          invalid_angel.errors.messages.should == {
              :first_name=>["can't be blank"],
              :last_name=>["can't be blank"],
              :email=>["can't be blank"],
              :gender=>["must be selected"]}
        end
      end

      context "de" do
        before(:each) { I18n.locale = :de }

        it "should have German errors" do
          invalid_angel = Angel.create
          invalid_angel.errors.messages.should == {
              :first_name=>["muss ausgefüllt werden"],
              :last_name=>["muss ausgefüllt werden"],
              :email=>["muss ausgefüllt werden"],
              :gender=>["muss ausgewählt werden"]}
        end
      end
    end
  end

  context "helpers when valid" do
    let(:angel) { Factory.create(:full_angel,
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

  context "geocoding" do
    # remember google only allows so many geocode requests per/day/time/something
    # a failure here might be temporary
    it "should have been geocoded" do
      angel = Factory.create(:full_angel)
      angel.should be_geocoded
      angel.lat.should be_within(0.5).of(52.5234051)
      angel.lng.should be_within(0.5).of(13.4113999)
    end

    context "should require a geocode call" do
      it "when new" do
        angel = Factory.build(:full_angel)
        angel.should be_geocode_required
      end

      it "when address change" do
        angel = Factory.create(:full_angel)
        angel.should_not be_geocode_required
        angel.notes = "does not influence geocode"
        angel.should_not be_geocode_required
        angel.city = "london"
        angel.should be_geocode_required
      end
    end
  end

  context "scopes" do
    it "should order by_last_name" do
      z = Factory.create(:angel, :last_name => 'Zoo')
      b = Factory.create(:angel, :last_name => 'Bird')
      a = Factory.create(:angel, :last_name => 'Animal')
      all = Angel.by_last_name.all
      all.should == [a,b,z]
    end
  end

  context "vcards" do
    it "should generate a valid vcard" do
      angel = Factory.build(:full_angel)
      angel.to_vcard.should == "BEGIN:VCARD\nVERSION:3.0\nN:Park;Mike;;;\nFN:Mike Park\nADR;TYPE=home,pref:;;Somewhere 140;Berlin;;12345;DE\nEMAIL;TYPE=home:mikep@quake.net\nTEL;TYPE=home:030 12345\nTEL;TYPE=mobile:0151 1234\nTEL;TYPE=work:+49 151 5678\nNOTE:some long\\nmessage\\nthat is multiline\\n\nEND:VCARD\n"
    end
  end

  context "registrations" do
    it "should assign angel_id to added registrations" do
      angel = Factory.create(:angel)
      angel.registrations << Factory.build(:registration, :angel => nil)
      angel.save
      angel.registrations.count.should == 1
    end
  end


  context "highest level" do
    it "should match the highest completed level" do
      angel = Factory.create(:angel)
      other_angel = Factory.create(:angel)
      event1 = Factory.create(:event1)
      event3 = Factory.create(:event3)
      event5 = Factory.create(:event5)
      Factory.create(:registration,
                     :angel => angel,
                     :event => event3,
                     :completed => true)
      Factory.create(:registration,
                     :angel => angel,
                     :event => event1,
                     :completed => true)
      Factory.create(:registration,
                     :angel => angel,
                     :event => event5,
                     :completed => false)
      Factory.create(:registration,
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
    it "should also delete registrations" do
      angel = Factory.create(:angel)
      registration = Factory.create(:registration, :angel => angel)
      Angel.should have(1).record
      Registration.should have(1).record

      angel.destroy

      Angel.should have(:no).records
      Registration.should have(:no).records
    end
  end

  context "to_csv" do
    let(:angel) { Factory.create(:full_angel) }
    it "should convert angel to_csv" do
      Angel.to_csv([angel]).should == "\"Full name\",\"Email\",\"Highest level\",\"Gender\",\"Address\",\"Postal code\",\"City\",\"Country\",\"Home phone\",\"Mobile phone\",\"Work phone\"\n\"Mike Park\",\"mikep@quake.net\",\"0\",\"Male\",\"Somewhere 140\",\"12345\",\"Berlin\",\"DE\",\"030 12345\",\"0151 1234\",\"+49 151 5678\"\n"
    end
  end

  context "with duplicates" do
    let(:angel1) { Factory.create(:angel,
                                  :notes => 1,
                                  :home_phone => 'something') }
    let(:angel2) { Factory.create(:angel,
                                  :first_name => 'mike',
                                  :last_name => 'park',
                                  :notes => 2,
                                  :home_phone => nil) }
    let(:l1) { Factory.create(:event1) }
    let(:l3) { Factory.create(:event3) }
    let(:l5) { Factory.create(:event5) }
    before(:each) do
      Factory.create(:registration, :event => l1, :angel => angel1, :completed => true)
      Factory.create(:registration, :event => l3, :angel => angel1, :completed => true)
      Factory.create(:registration, :event => l1, :angel => angel2, :completed => true)
      Factory.create(:registration, :event => l5, :angel => angel2, :completed => true)
    end

    it { Angel.count.should == 2 }
    it { Angel.find(1).notes.should == '1' }
    it { Angel.find(1).home_phone.should == 'something' }
    it { Angel.find(2).notes.should == '2' }
    it { Angel.find(2).home_phone.should_not be }
    it { Event.count.should == 3 }
    it { Registration.count.should == 4 }

    context "should merged into angel1" do
      #before(:each) do
      #  ActiveRecord::Base.logger = Logger.new(STDOUT)
      #  ActiveRecord::Base.clear_active_connections!
      #end

      it "from one other angel" do
        Angel.merge_and_delete_duplicates_of(angel2).should == 1
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
        it { Event.count.should == 3 }
        it { Registration.count.should == 3 }
        it { angel1.registrations.count.should == 3 }
        it { angel1.highest_level.should == 5 }

      end
    end
  end
end

# == Schema Information
#
# Table name: angels
#
#  id            :integer         primary key
#  display_name  :string(255)     not null
#  first_name    :string(255)
#  last_name     :string(255)     not null
#  gender        :string(255)     not null
#  address       :string(255)
#  postal_code   :string(255)
#  city          :string(255)
#  country       :string(255)
#  email         :string(255)     not null
#  home_phone    :string(255)
#  mobile_phone  :string(255)
#  work_phone    :string(255)
#  lang          :string(255)
#  notes         :text
#  created_at    :timestamp
#  updated_at    :timestamp
#  highest_level :integer         default(0)
#  lat           :float
#  lng           :float
#

