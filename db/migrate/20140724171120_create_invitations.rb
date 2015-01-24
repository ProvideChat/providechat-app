class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :organization_id
      t.integer :website_id
      t.string :invitation_message
      t.string :name_text
      t.string :button_text
      t.integer :invite_mode
      t.integer :invite_pageviews
      t.integer :invite_seconds

      t.timestamps null: false
    end
  end
end
