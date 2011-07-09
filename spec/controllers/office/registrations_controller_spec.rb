require 'spec_helper'

describe Office::RegistrationsController do
  login_staff
  before(:each) do
    @event = Factory.create(:event)
  end
  
  describe "GET new" do
    it "should be successful" do
      get :new, :event_id => @event
      response.should be_success
    end

    it "should build subject object" do
      get :new, :event_id => @event
      assigns[:registration].should be
    end
  end

  describe "POST create" do
    it "should assign to @registration" do
      post :create, :event_id => @event
      assigns[:registration].should be
    end

    it "should fix some values in @registration" do
      post :create, :event_id => @event
      assigns[:registration].should be_approved
    end

    it "should redirect to pre on success" do
      registration = mock_model(Registration)
      registration.should_receive(:approved=)
      registration.stub(:save).and_return(true)
      Registration.stub(:new).and_return(registration)
      post :create, :event_id => @event
      response.should redirect_to("/#{I18n.locale}/office/events/#{@event.id}/pre")
    end
  end
end
