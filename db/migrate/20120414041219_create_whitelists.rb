class CreateWhitelists < ActiveRecord::Migration
  def change
    create_table :whitelists do |t|
      t.string :email
      t.string :name
      t.string :gender

      t.timestamps
    end
  end
end
