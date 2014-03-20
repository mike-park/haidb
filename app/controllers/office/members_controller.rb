class Office::MembersController < Office::ApplicationController
  before_filter :team

  def index
    @members = team.members
  end

  def show
    @member = team.members.find(params[:id])
  end

  def new
    @member = team.members.build
  end

  def edit
    @member = team.members.find(params[:id])
  end

  def refresh
    team.members.each do |member|
      update_from_membership(member)
      member.save!
    end
    redirect_to [:office, team], notice: 'Membership statuses updated'
  end

  def create
    @member = team.members.build(params[:member])
    update_from_membership(@member)
    if @member.save
      redirect_to [:office, team], notice: 'Member was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @member = team.members.find(params[:id])
    update_from_membership(@member)
    if @member.update_attributes(params[:member])
      redirect_to [:office, team], notice: 'Member was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @member = team.members.find(params[:id])
    @member.destroy

    redirect_to [:office, team]
  end

  private

  def update_from_membership(member)
    angel = member.membership.angel
    member.angel = angel
    member.full_name = angel.full_name
    member.gender = angel.gender
    member.status = member.membership.status
  end

  def team
    @team ||= Team.find(params[:team_id])
  end
end
