class Users::MembersController < Users::SignedInController
  before_filter :team
  before_filter :member, except: [:create]

  def create
    member = build_member
    message = member.save ? 'You have been added to this team' : 'You could not be added to this team'
    redirect_back(message)
  end

  def update
    message = if member.update_attributes(params[:member])
                'Successfully updated'
              else
                'Could not be updated'
              end
    redirect_back(message)
  end

  def destroy
    member.destroy
    redirect_back('You have been removed from this team')
  end

  private

  def redirect_back(message)
    redirect_to [:users, team], notice: message
  end

  def team
    @team ||= Team.find(params[:team_id])
  end

  def angel
    current_user.angel
  end

  def build_member
    @member ||= team.members.build(angel: angel, full_name: angel.full_name, membership: membership,
                                   gender: angel.gender, status: membership.status)
  end

  def member
    @member ||= angel.members.where(team_id: team.id).first
  end

  def membership
    angel.active_membership
  end
end