class AddNameToAdFiles < ActiveRecord::Migration
  def up
    add_column :ad_files, :name, :string
  end
  
  def down
    remove_column :ad_files, :name, :string
  end
end
