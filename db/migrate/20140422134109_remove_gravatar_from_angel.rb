class RemoveGravatarFromAngel < ActiveRecord::Migration
  def change
    remove_column :angels, :gravatar
  end
end
