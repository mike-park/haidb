class AddStatusToRegistration < ActiveRecord::Migration
  def up
    ids = Registration.select([:id, :approved]).find_all { |r| r.approved }.map(&:id)
    remove_column :registrations, :approved
    add_column :registrations, :status, :string, default: 'pending'
    add_index :registrations, :status
    Registration.reset_column_information
    Registration.update_all(status: 'approved')

    %w(pending waitlisted).each do |status|
      ids = PublicSignup.where(status: status).map {|p| p.registration.id}
      Registration.update_all({status: status}, id: ids)
    end
    # later remove status from PublicSignup
  end

  def down
    ids = Registration.select([:id, :status]).find_all { |r| r.status == 'approved' }.map(&:id)
    remove_column :registrations, :status
    add_column :registrations, :approved, :boolean, default: false
    Registration.reset_column_information
    Registration.update_all({approved: true}, id: ids)
  end

  class Registration < ActiveRecord::Base
    belongs_to :public_signup
  end
  class PublicSignup < ActiveRecord::Base
    has_one :registration
  end
end
