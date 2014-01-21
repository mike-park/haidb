class Office::TeamsController < Office::ApplicationController
  before_filter :group_team_members

  def index
    respond_to do |format|
      format.html
      format.csv do
        send_data Angel.to_csv(team_members), {
            :filename => filename('.csv'),
            :type => :csv
        }
      end
      format.vcard do
        send_data Angel.to_vcard(team_members), {
            :filename => filename('.vcf'),
            :type => :vcard
        }
      end
    end
  end

  private

  def filename(extension)
    "#{team_group_status}_team_members#{extension}"
  end

  def team_group_status
    params[:status] || 'active'
  end

  def group_team_members
    pages = {
        active: [
            ['Active Team', 12],
            ['Current Team', 18],
            ['Recently Expired Team', 24]
        ],
        current: [
            ['Current Team', 18],
            ['Recently Expired Team', 24]
        ],
        all: [
            ['Every team person', 12*20]
        ]
    }

    groupings = pages[team_group_status.to_sym] || pages[:active]

    previously_seen = []
    @team_groups = []
    groupings.each do |(name, months)|
      target_date = Date.current - months.send(:months)
      members_since = TeamMember.team_members_since(target_date)
      new_seen = members_since - previously_seen
      team_group = TeamGroup.new(name, new_seen, months)
      @team_groups.push(team_group)
      previously_seen += new_seen
    end
  end

  def team_members
    @team_groups.first.members
  end
end
