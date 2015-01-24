class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :organization_id
      t.integer :website_id
      t.integer :visitor_id
      t.integer :agent_id, :default => 0
      t.string :agent_typing, :default => ''
      t.string :visitor_typing, :default => ''
      t.timestamp :chat_requested
      t.timestamp :chat_accepted
      t.timestamp :chat_ended
      t.string :visitor_name, :default => ''
      t.string :visitor_email, :default => ''
      t.string :visitor_department, :default => ''
      t.string :visitor_question, :default => ''
      t.integer :status

      t.timestamps null: false
    end

    add_index :chats, :organization_id
    add_index :chats, :website_id
  end
end
