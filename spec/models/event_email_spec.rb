require 'spec_helper'

describe EventEmail do
  context "#new validations" do
    it "requires a valid category" do
      ee = EventEmail.new
      ee.should_not be_valid
      ee.category = EventEmail::CATEGORIES.first
      ee.should be_valid
      ee.category = "something"
      ee.should_not be_valid
    end

    it "should have a valid factory" do
      ee = Factory.build(:event_email)
      ee.should be_valid
    end

    it "validates uniqueness of category" do
      ee = Factory.create(:event_email)
      ee2 = ee.dup
      ee2.should_not be_valid
      # change category & be valid
      ee2.category = EventEmail::CATEGORIES.last
      ee2.should be_valid
    end
  end

  context "delegations" do
    let(:email_name) { EmailName.new(name: "name") }
    subject { Factory.build(:event_email, email_name: email_name) }
    it "should call name" do
      subject.name.should == "name"
    end
    it "should call email" do
      email_name.should_receive(:email).with('de').and_return("found")
      subject.email('de').should == 'found'
    end
  end
end

# == Schema Information
#
# Table name: event_emails
#
#  id            :integer         not null, primary key
#  email_name_id :integer
#  event_id      :integer
#  category      :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

