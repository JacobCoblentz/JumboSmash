class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :gender
      t.string :facebook_id
      t.string :picture_url

      t.timestamps
    end
  end
end
