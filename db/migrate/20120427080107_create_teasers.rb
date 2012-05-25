class CreateTeasers < ActiveRecord::Migration
  def change
    create_table :teasers do |t|
      t.string :email

      t.timestamps
    end
  end
end
