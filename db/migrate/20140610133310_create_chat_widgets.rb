class CreateChatWidgets < ActiveRecord::Migration
  def change
    create_table :chat_widgets do |t|
      t.integer :organization_id
      t.integer :website_id
      t.string :online_message
      t.string :offline_message
      t.boolean :hide_when_offline
      t.string :colour
      t.boolean :display_logo
      t.boolean :display_agent_avatar
      t.boolean :display_mobile_icon

      t.timestamps
    end
  end
end
