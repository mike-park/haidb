class Office::TeamAssignmentsController < Office::ApplicationController
  before_filter :team

  def create
    options = if event
                preform_assignment || {notice: 'Members transferred'}
              else
                {notice: 'No event available for assignment'}
              end
    team.update_attribute(:closed, true)
    redirect_to office_team_path(team), options
  end

  private

  def preform_assignment
    errors = team.members.includes(:angel).map do |member|
      registration = member.assign_to(event)
      unless registration.valid?
        "#{member.full_name}: [#{errors(registration)}]"
      end
    end.compact
    if errors.any?
      { alert: errors.join('<br>').html_safe }
    end
  end

  def errors(registration)
    registration.errors.full_messages.join(', ')
  end

  def team
    @team ||= Team.find(params[:id])
  end

  def event
    @event ||= team.event
  end
end