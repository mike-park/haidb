require 'spec_helper'

describe 'Language Switching' do
  before do
    Site.stub(name: 'de')
  end

  it "displays in english" do
    visit '/'
    expect(page).to have_content('First name')
  end
  it "displays in german" do
    visit '/?locale=de'
    expect(page).to have_content('Vorname')
  end
  it "displays in english again" do
    visit '/'
    expect(page).to have_content('First name')
  end
end