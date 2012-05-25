class AddPrivateKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :private_key, :text

  end
end
