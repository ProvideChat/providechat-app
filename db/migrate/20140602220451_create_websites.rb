class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.integer :organization_id
      t.string :url,    null: false, default: ""
      t.string :name,   null: false, default: ""
      t.string :email,  null: false, default: ""
      t.timestamp :last_ping
      t.boolean :smart_invites
      t.string :smart_invite_mode

      t.timestamps null: false
    end

    add_index :websites, :organization_id
  end
end
