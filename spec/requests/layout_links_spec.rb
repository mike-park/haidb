require 'spec_helper'

describe "LayoutLinks" do
  it "should have English signup page at /en/public_signup/new" do
    get "/en/public_signup/new"
  end
end
