class AddForeignKeyToAdFiles < ActiveRecord::Migration
  def change
    add_foreign_key :ad_files, :users
  end
end
