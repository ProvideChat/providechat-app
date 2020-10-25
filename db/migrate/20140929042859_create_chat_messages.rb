class CreateChatMessages < ActiveRecord::Migration[4.2]
  def change
    create_table :chat_messages do |t|
      t.integer :chat_id
      t.string :user_name
      t.integer :sender
      t.timestamp :sent
      t.boolean :seen_by_agent, default: false
      t.boolean :seen_by_visitor, default: false
      t.text :message

      t.timestamps null: false
    end
  end
end
