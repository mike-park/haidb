class AddAngelToUser < ActiveRecord::Migration
  def change
    add_column :users, :angel_id, :integer
    add_column :users, :options, :text
  end
end
