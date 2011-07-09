require 'spec_helper'

if Site.name == 'de'
  describe 'public_signups/de/new.html.haml' do
    before(:each) do 
      assign(:basedir, "public_signups/de")
      assign(:public_signup, Factory.build(:public_signup))
      view.stub(:language?).and_return(false)
    end
    
    it "renders a form to create a public_signup" do
      render
      rendered.should have_selector('form',
                                    :method => 'post',
                                    :action => public_signups_path) do |form|
        form.should have_selector(:input, :type => 'submit')
      end
    end
    
    context "should render in English" do
      before(:each) do
        I18n.locale = :en
        render
      end
      
      it "the form labels" do
        rendered.should have_selector('label', :content => "First name")
      end
      
      it "the title" do
        rendered.should contain("Registration for HAI/Hand-on-Heart Workshop")
      end
      
      it "no payment field" do
        rendered.should_not have_selector('#public_signup_registration_attributes_payment_method_input')
      end
      
      it "the link to English version" do
        rendered.should have_selector('a', :href => '/de/public_signups/new')
      end
      
      it "the payment information" do
        rendered.should match("To pay for the workshop")
      end
      
      it "the backjack rental field" do
        rendered.should have_selector('#public_signup_registration_attributes_backjack_rental_input')
      end
    end
    
    context "renders in German" do
      before(:all) do
        I18n.locale = :de
      end
      before(:each) do
        view.stub(:language?).and_return(true)
        render
      end      
      
      it "the form labels" do
        rendered.should have_selector('label', :content => "Vorname")
      end
      
      it "the title" do
        rendered.should contain("Anmeldung")
      end
      
      it "the link to English version" do
        rendered.should have_selector('a', :href => '/en/public_signups/new')
      end
      
      it "the payment field" do
        rendered.should have_selector('#public_signup_registration_attributes_payment_method_input')
      end
    end
  end
end
