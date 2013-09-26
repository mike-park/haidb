class AddGravatarToAngel < ActiveRecord::Migration
  def change
    add_column :angels, :gravatar, :text
  end
end
