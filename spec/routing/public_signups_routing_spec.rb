require "spec_helper"

describe PublicSignupsController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/public_signups/new" }.should route_to(:controller => "public_signups", :action => "new")
    end

    it "recognizes and generates #create" do
      { :post => "/public_signups" }.should route_to(:controller => "public_signups", :action => "create")
    end

  end
end
