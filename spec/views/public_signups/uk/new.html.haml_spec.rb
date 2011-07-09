require 'spec_helper'

if Site.name == 'uk'
  describe 'public_signups/uk/new.html.haml' do
    before(:each) do 
      I18n.locale = :en
      assign(:public_signup, Factory.build(:public_signup))
      render
    end
    
    it "renders a form to create a public_signup" do
      rendered.should have_selector('form',
                                    :method => 'post',
                                    :action => public_signups_path) do |form|
        form.should have_selector(:input, :type => 'submit')
      end
    end
    
    it "should have English form labels" do
      rendered.should have_selector('label', :content => "First name")
    end
    
    it "should have the title" do
      rendered.should contain("Registration for HAI Workshop")
    end
    
    it "should have no payment field" do
      rendered.should_not have_selector('#public_signup_registration_attributes_payment_method_input')
    end
    
    it "should not have a link to German version" do
      rendered.should_not match("Bitte melden Sie")
    end
    
    it "should not have payment information" do
      rendered.should_not match("To pay for the workshop")
    end
    
    it "should not have backjack rental field" do
      rendered.should_not have_selector('#public_signup_registration_attributes_backjack_rental_input')
    end
  end
end
