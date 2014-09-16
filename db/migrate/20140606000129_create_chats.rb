class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :organization_id
      t.integer :website_id
      t.integer :visitor_id
      t.integer :agent_id
      t.string :agent_typing
      t.string :visitor_typing
      t.timestamp :chat_requested
      t.timestamp :chat_accepted
      t.timestamp :chat_ended
      t.string :visitor_name
      t.string :visitor_email
      t.string :visitor_department
      t.string :visitor_question
      t.integer :status

      t.timestamps
    end

    add_index :chats, :organization_id
    add_index :chats, :website_id
  end
end
