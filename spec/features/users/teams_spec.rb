require 'spec_helper'

describe "teams" do
  context "without a login" do
    it "should redirect to login page" do
      visit users_teams_path
      expect(page).to have_css('.sessions.new')
    end
  end

  context "with a valid login" do
    let(:user) { create(:user, angel: create(:angel)) }

    before do
      user.confirm!
      user_login(user)
      visit users_root_path
    end

    context "as a normal user" do
      it "should not show the team tab" do
        expect(page).to_not have_link('Team')
      end
    end

    context "as a team user" do
      let(:team1) { create(:team, date: Date.yesterday) }
      let(:team2) { create(:team, date: Date.tomorrow) }
      let(:team3) { create(:team, date: Date.current + 1.week, closed: true) }
      let(:teams) { [team1, team2, team3] }

      before do
        user.angel.memberships << create(:membership)
        teams
        visit users_root_path
        click_on 'Team'
      end

      it "should show the teams page" do
        expect(page).to have_css('.teams.index')
      end

      it "should not show teams from the past" do
        expect(page).to_not have_content(team1.name)
      end

      it "should show upcoming teams" do
        expect(page).to have_content(team2.name)
        expect(page).to have_content(team3.name)
      end

      it "should have links to view the teams" do
        expect(page).to have_link(team2.name, href: users_team_path(team2))
        expect(page).to have_link(team3.name, href: users_team_path(team3))
      end
    end
  end
end
