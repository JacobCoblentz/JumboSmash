class CreateConnectionQueues < ActiveRecord::Migration

  def change
    create_table :connection_queues do |t|
      t.integer :user_id
      t.text :message_body
      t.string :message_type

      t.timestamps
    end
  end
end
