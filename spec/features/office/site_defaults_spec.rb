require 'spec_helper'

describe "site_defaults" do
  before do
    office_login
  end

  it "should have Emails tab" do
    visit office_site_defaults_path
    page.should have_content("Email Templates")
  end
end
