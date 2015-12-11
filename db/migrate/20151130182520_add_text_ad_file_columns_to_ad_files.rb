class AddTextAdFileColumnsToAdFiles < ActiveRecord::Migration
  def up
    add_attachment :ad_files, :text_ad_file
  end
  
  def down
    add_attachment :ad_files, :text_ad_file
  end
end
