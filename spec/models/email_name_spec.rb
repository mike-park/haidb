require 'spec_helper'

describe EmailName do
  context "#new validation" do
    it "accepts nested attributes for email" do
      email = FactoryGirl.build(:email)
      email_name = EmailName.new(emails_attributes: [email.attributes, email.attributes])
      email_name.emails.size.should == 2
    end

    it "requires name" do
      email_name = EmailName.new
      email_name.should_not be_valid
      email_name.name = "me"
      email_name.should be_valid
    end
  end

  it ".add_missing_locales adds missing locales" do
    en = EmailName.new
    available_locales = ['en','de','fr']
    Site.stub(:available_locales).and_return(available_locales)
    en.emails.size.should == 0
    en.emails.build(locale: 'de')
    en.add_missing_locales
    en.emails.size.should == 3
    en.emails.map(&:locale).should include(*available_locales)
  end

  it ".email returns a locale email" do
    en = FactoryGirl.create(:email_name)
    en_email = FactoryGirl.create(:en_email, email_name: en)
    de_email = FactoryGirl.create(:de_email, email_name: en)
    en.email('de').should == de_email
    en.email('en').should == en_email
    en.email(:en).should == en_email
  end
end

# == Schema Information
#
# Table name: email_names
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

