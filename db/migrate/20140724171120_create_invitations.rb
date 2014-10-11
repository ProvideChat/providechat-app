class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :organization_id
      t.integer :website_id
      t.string :invitation_message
      t.integer :invite_mode
      t.integer :invite_pageviews
      t.integer :invite_seconds

      t.timestamps
    end
  end
end
