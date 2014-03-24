class Users::TeamsController < Users::SignedInController
  def index
    @teams = Team.upcoming.by_date
  end

  def show
    @team = Team.find(params[:id])
  end
end
