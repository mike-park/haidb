require 'spec_helper'

describe "roster" do
  before do
    office_login
  end

  let(:event) { FactoryGirl.create(:event) }
  subject { roster_office_event_registrations_path(event) }

  it "pdf request sends a pdf file" do
    visit subject
    current_path.should == subject
    #save_and_open_page
    click_link 'PDF Format'
    page.status_code.should == 200
    page.response_headers['Content-Type'].should == 'application/pdf'
    page.response_headers['Content-Transfer-Encoding'].should == 'binary'
    page.response_headers['Content-Disposition'].should match("attachment; filename=\"#{event.display_name} roster.pdf\"")
  end
end
