class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :user_id
      t.text :description
      t.text :location
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
