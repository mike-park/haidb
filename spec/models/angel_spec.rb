# -*- coding: utf-8 -*-
require 'spec_helper'

# special notes: angel is autogeocoded before saving. should stub out this need unless
# actually testing geocoding

describe Angel do
  context "#new validation" do
    it "is valid with min attributes" do
      valid_angel = FactoryGirl.create(:angel)
      valid_angel.should be_valid
    end

    it "is valid with all attributes" do
      valid_angel = FactoryGirl.create(:full_angel)
      valid_angel.should be_valid
    end

    it "is invalid without first_name" do
      in_valid_angel = FactoryGirl.build(:angel, :first_name => '')
      in_valid_angel.should_not be_valid
    end

    it "is invalid without last_name" do
      in_valid_angel = FactoryGirl.build(:angel, :last_name => '')
      in_valid_angel.should_not be_valid
    end

    it "is invalid without email" do
      in_valid_angel = FactoryGirl.build(:angel, :email => '')
      in_valid_angel.should_not be_valid
    end

    it "is valid without gender" do
      valid_angel = FactoryGirl.build(:angel, :gender => nil)
      valid_angel.should be_valid
    end

    it "is invalid with other build" do
      in_valid_angel = FactoryGirl.build(:angel, :gender => 'Other')
      in_valid_angel.should_not be_valid
    end

    it "is valid with each gender" do
      Registration::GENDERS.each do |gender|
        valid_angel = FactoryGirl.build(:angel, :gender => gender)
        valid_angel.should be_valid
      end
    end

    context "language of messages" do

      context "en" do
        before(:each) { I18n.locale = :en }

        it "should have English errors" do
          invalid_angel = Angel.create
          invalid_angel.errors.messages.should == {
              :first_name => ["can't be blank"],
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
              :first_name => ["muss ausgefüllt werden"],
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
    let(:registration) { FactoryGirl.create(:registration) }
    it "should create a new angel" do
      Angel.count.should == 0
      Angel.add_to(registration)
      Angel.count.should == 1
    end
  end

  context "geocoding" do
    # remember google only allows so many geocode requests per/day/time/something
    # a failure here might be temporary
    it "should have been geocoded" do
      angel = FactoryGirl.create(:full_angel)
      angel.should be_geocoded
      angel.lat.should be_within(0.5).of(52.5234051)
      angel.lng.should be_within(0.5).of(13.4113999)
    end

    context "should require a geocode call" do
      it "when new" do
        angel = FactoryGirl.build(:full_angel)
        angel.send(:gmaps).should == false
      end

      it "when address change" do
        angel = FactoryGirl.create(:full_angel)
        angel.send(:gmaps).should == true
        angel.notes = "does not influence geocode"
        angel.send(:gmaps).should == true
        angel.city = "london"
        angel.send(:gmaps).should == false
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

  context "vcards" do
    it "should generate a valid vcard" do
      angel = FactoryGirl.build(:full_angel)
      angel.to_vcard.should == "BEGIN:VCARD\nVERSION:3.0\nN:Park;Mike;;;\nFN:Mike Park\nADR;TYPE=home,pref:;;Somewhere 140;Berlin;;12345;DE\nEMAIL;TYPE=home:mikep@quake.net\nTEL;TYPE=home:030 12345\nTEL;TYPE=mobile:0151 1234\nTEL;TYPE=work:+49 151 5678\nNOTE:some long\\nmessage\\nthat is multiline\\n\nEND:VCARD\n"
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
    it "should also delete registrations" do
      angel = FactoryGirl.create(:angel)
      registration = FactoryGirl.create(:registration, :angel => angel)
      Angel.should have(1).record
      Registration.should have(1).record

      angel.destroy

      Angel.should have(:no).records
      Registration.should have(:no).records
    end
  end

  context "to_csv" do
    let(:angel) { FactoryGirl.create(:full_angel) }
    it "should convert angel to_csv" do
      Angel.to_csv([angel]).should == "\"Full name\",\"Email\",\"Highest level\",\"Gender\",\"Address\",\"Postal code\",\"City\",\"Country\",\"Home phone\",\"Mobile phone\",\"Work phone\"\n\"Mike Park\",\"mikep@quake.net\",\"0\",\"Male\",\"Somewhere 140\",\"12345\",\"Berlin\",\"DE\",\"030 12345\",\"0151 1234\",\"+49 151 5678\"\n"
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
