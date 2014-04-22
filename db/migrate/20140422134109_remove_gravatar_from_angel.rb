class RemoveGravatarFromAngel < ActiveRecord::Migration
  def change
    remove_column :angels, :gravatar, :text

    # cause before_save callbacks to run to redo display name
    Angel.find_each {|a| a.save}
  end
end
