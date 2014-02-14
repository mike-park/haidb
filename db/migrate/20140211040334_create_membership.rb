class CreateMembership < ActiveRecord::Migration
  def up
    create_table :memberships do |t|
      t.references :angel
      t.string :status
      t.date :active_on
      t.date :retired_on
      t.text :notes
      t.text :options
      t.decimal :participant_cost, :precision => 10, :scale => 2
      t.decimal :team_cost, :precision => 10, :scale => 2
      t.timestamps
    end
    add_index :memberships, :angel_id
    add_index :memberships, :status

    Audit.as_user(Staff.first) do
      TeamMember.create_memberships
    end
  end

  def down
    remove_index :memberships, :angel_id
    remove_index :memberships, :status
    drop_table :memberships
  end

  class TeamMember < SimpleDelegator
    def self.create_memberships
      angels = team_members_since(Date.current - 20.years)
      angels.each do |angel|
        membership = Membership.new(angel: angel)
        member = new(angel)
        workshops = member.on_team_or_team_workshops
        membership.active_on = workshops.first.start_date
        membership.retired_on = (workshops.last.start_date + 18.months).end_of_month
        membership.retired_on = nil if membership.retired_on > Date.current

        workshops = member.on_team
        membership.status = if workshops.length == 0
                              Membership::AWS
                            elsif workshops.length <= 3
                              if workshops.map(&:level).compact.select { |level| level >= 5 }.any?
                                Membership::EXPERIENCED
                              else
                                Membership::NOVICE
                              end
                            else
                              Membership::EXPERIENCED
                            end
        membership.save!
      end
    end

    def self.team_members_since(date)
      (on_team_angels_since(date) + in_team_workshop_angels_since(date)).sort.uniq
    end

    def eql?(other)
      id.eql?(other.id)
    end

    def ==(other)
      eql?(other)
    end

    def on_team
      registrations.team.completed.by_start_date
    end

    def team_workshops
      registrations.non_facilitators.completed.team_workshops.by_start_date
    end

    def on_team_or_team_workshops
      (on_team + team_workshops).sort.uniq
    end

    private

    def self.on_team_angels_since(date)
      Registration.team.completed.since(date).map(&:angel)
    end

    def self.in_team_workshop_angels_since(date)
      Registration.ok.non_facilitators.team_workshops.completed.since(date).map(&:angel)
    end
  end
end
