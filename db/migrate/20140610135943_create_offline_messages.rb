class CreateOfflineMessages < ActiveRecord::Migration
  def change
    create_table :offline_messages do |t|
      t.integer :organization_id
      t.integer :website_id
      t.string :intro_text
      t.string :name_text
      t.String :email_text
      t.boolean :email_enabled
      t.string :department_text
      t.boolean :department_enabled
      t.string :message_text
      t.string :button_text
      t.text :success_message

      t.timestamps
    end
  end
end
