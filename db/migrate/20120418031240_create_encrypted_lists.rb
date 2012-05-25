class CreateEncryptedLists < ActiveRecord::Migration
  def change
    create_table :encrypted_lists do |t|
      t.text :matched
      t.text :requests
      t.text :pending
      t.integer :user_id

    end
  end
end
