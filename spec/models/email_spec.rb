require 'spec_helper'

describe Email do
  context "#new validation" do
    it "should have a valid factory email" do
      email = FactoryGirl.build(:email)
      email.should be_valid
    end

    [:locale, :subject, :body].each do |attr|
      it "should require #{attr}" do
        email = FactoryGirl.build(:email, attr => " ")
        email.should_not be_valid
      end
    end

    context "en langauge" do
      before(:each) do
        I18n.locale = :en
      end
      it "should limit 1 locale per email_name" do
        email = FactoryGirl.create(:email, email_name_id: 1)
        email2 = email.dup
        email2.should_not be_valid
        email2.errors.messages.should include(locale: ['has already been taken'])
      end
    end
  end
end

# == Schema Information
#
# Table name: emails
#
#  id            :integer         not null, primary key
#  email_name_id :integer
#  locale        :string(255)
#  subject       :string(255)
#  body          :text
#  created_at    :datetime
#  updated_at    :datetime
#

