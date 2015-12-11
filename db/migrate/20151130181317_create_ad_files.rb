class CreateAdFiles < ActiveRecord::Migration
  def change
    create_table :ad_files do |t|

      t.timestamps null: false
    end
  end
end
