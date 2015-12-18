class AddPlatformToAdFiles < ActiveRecord::Migration
  def up
    add_column :ad_files, :platform, :string
  end
  
  def down
    remove_column :adfiles, :platform, :string
  end
end
