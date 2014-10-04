class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.integer :chat_id
      t.string :user_name
      t.string :sender
      t.string :message_type
      t.timestamp :sent
      t.boolean :seen_by_agent
      t.boolean :seen_by_visitor
      t.text :message

      t.timestamps
    end
  end
end
