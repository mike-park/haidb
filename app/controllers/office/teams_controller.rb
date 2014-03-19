class Office::TeamsController < Office::ApplicationController
  def index
    @teams = Team.upcoming.by_date
  end

  def past
    @teams = Team.previous.by_date_desc
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def edit
    @team = Team.find(params[:id])
  end

  def create
    @team = Team.new(params[:team])
    set_defaults(@team)
    if @team.save
      redirect_to [:office, @team], notice: 'Team was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @team = Team.find(params[:id])

    if @team.update_attributes(params[:team])
      redirect_to [:office, @team], notice: 'Team was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    redirect_to office_teams_url
  end

  private

  def set_defaults(team)
    event = team.event
    if event
      team.name = event.display_name unless team.name.present?
      team.date ||= event.start_date
    end
  end
end
