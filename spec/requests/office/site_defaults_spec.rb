require 'spec_helper'

describe "site_defaults" do
  office_login

  it "should have Emails tab" do
    visit office_site_defaults_path
    page.should have_content("Email Templates")
  end
end
