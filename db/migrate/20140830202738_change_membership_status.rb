class ChangeMembershipStatus < ActiveRecord::Migration
  def up
    Membership.where(status: %w(AWS/TWS Preliminary)).update_all(status: 'Provisional')
    Membership.where(status: 'TeamCo').update_all(status: 'Experienced')
  end

  def down
  end
end
