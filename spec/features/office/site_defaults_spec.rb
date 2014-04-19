require 'spec_helper'

describe "site_defaults", js: true do
  before do
    office_login
    visit office_root_path
  end

  it "should have nav" do
    expect(page).to have_content('Site Defaults')
  end

  context "nav links" do
    before do
      click_link('Site Defaults')
    end

    it "should have keys" do
      click_link('Keys')
      expect(page).to have_link('New')
    end

    it "should have emails" do
      click_link('Emails')
      expect(page).to have_link('New')
    end
  end
end
