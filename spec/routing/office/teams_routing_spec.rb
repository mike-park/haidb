require "spec_helper"

describe Office::TeamsController do
  describe "routing" do

    it "routes to #index" do
      get("/office/teams").should route_to("office/teams#index")
    end

    it "routes to #new" do
      get("/office/teams/new").should route_to("office/teams#new")
    end

    it "routes to #show" do
      get("/office/teams/1").should route_to("office/teams#show", :id => "1")
    end

    it "routes to #edit" do
      get("/office/teams/1/edit").should route_to("office/teams#edit", :id => "1")
    end

    it "routes to #create" do
      post("/office/teams").should route_to("office/teams#create")
    end

    it "routes to #update" do
      put("/office/teams/1").should route_to("office/teams#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/office/teams/1").should route_to("office/teams#destroy", :id => "1")
    end

  end
end
