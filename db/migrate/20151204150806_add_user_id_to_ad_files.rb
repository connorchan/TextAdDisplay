class AddUserIdToAdFiles < ActiveRecord::Migration
  def change
    add_column :ad_files, :user_id, :integer
  end
end
