class ChangeSpecialDiet < ActiveRecord::Migration
  def up
    special_diet_ids = Registration.select([:id, :special_diet]).find_all {|r| r.special_diet }.map(&:id)
    remove_column :registrations, :special_diet
    add_column :registrations, :special_diet, :string
    Registration.reset_column_information
    Registration.update_all({special_diet: 'Vegi'}, id: special_diet_ids)
  end

  def down
    special_diet_ids = Registration.select([:id, :special_diet]).find_all {|r| r.special_diet.present? }.map(&:id)
    remove_column :registrations, :special_diet
    add_column :registrations, :special_diet, :boolean, default: false
    Registration.reset_column_information
    Registration.update_all({special_diet: true}, id: special_diet_ids)
  end

  class Registration < ActiveRecord::Base
  end
end
