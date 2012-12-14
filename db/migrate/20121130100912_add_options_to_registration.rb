class AddOptionsToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :options, :text
  end
end
