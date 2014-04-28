require 'spec_helper'

describe 'members' do
  let(:team) { create(:team, date: Date.tomorrow) }
  before do
    team
  end

  context "without a login" do
    it "should redirect to login page" do
      visit edit_users_team_member_path(team)
      expect(page).to have_css('.sessions.new')
    end
  end

  context "with a valid login" do
    let(:membership) { create(:membership) }
    let(:user) { create(:user, angel: membership.angel) }

    before do
      user.confirm!
      user_login(user)
      visit users_root_path
      click_on 'Team'
      click_on team.name
    end

    it "should add member to team" do
      find('.create-signup').click
      expect(page).to have_content(membership.full_name)
    end

    context "with current_user on team" do
      before do
        find('.create-signup').click
      end

      it "should add notes" do
        find('.edit-signup').click
        fill_in 'member[notes]', with: 'a long note'
        click_button('Update')
        expect(page).to have_content('Notes: a long note')
      end

      it "should remove user from team" do
        find('.edit-signup').click
        click_link 'remove-link'
        expect(page).to have_content('You have been removed')
      end
    end
  end
end
