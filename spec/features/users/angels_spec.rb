require 'spec_helper'

describe "angels" do
  it "should redirect to login page" do
    visit edit_users_angel_path
    page.should have_css('.sessions.new')
  end

  context "with a valid login" do
    let(:user) { create(:user, angel: angel) }

    before do
      user.confirm!
      user_login(user)
      visit users_root_path
    end

    context "with existing angel" do
      let(:angel) { create(:angel, gender: Registration::MALE) }

      it "should show the dashboards page" do
        page.should have_css('.dashboards.index')
      end

      it "should allow update of profile" do
        click_on 'Profil'
        choose(Registration::FEMALE)
        click_button 'submit_button'
        expect(page).to have_css('.dashboards.index')
        user.reload
        expect(user.angel.gender).to eq(Registration::FEMALE)
      end
    end

    context "without existing angel" do
      let(:angel) { nil }

      it "should show the angels new page" do
        page.should have_css('.angels.new')
      end

      it "should create a profile" do
        choose(Registration::FEMALE)
        fill_in 'angel[last_name]', with: 'last_name'
        click_button 'submit_button'
        expect(page).to have_css('.angels.show')
        user.reload
        expect(user.angel.gender).to eq(Registration::FEMALE)
        expect(user.angel.last_name).to eq('last_name')
      end
    end
  end
end
