class CreatePrechatForms < ActiveRecord::Migration
  def change
    create_table :prechat_forms do |t|
      t.integer :organization_id
      t.integer :website_id
      t.string :intro_text
      t.string :name_text
      t.string :email_text
      t.boolean :email_enabled
      t.string :department_text
      t.boolean :department_enabled
      t.string :message_text
      t.string :button_text

      t.timestamps
    end
  end
end
