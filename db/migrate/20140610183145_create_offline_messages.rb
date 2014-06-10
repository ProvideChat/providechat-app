class CreateOfflineMessages < ActiveRecord::Migration
  def change
    create_table :offline_messages do |t|
      t.integer :organization_id
      t.integer :website_id
      t.integer :visitor_id
      t.string :name
      t.string :email
      t.string :department
      t.text :message

      t.timestamps
    end
  end
end
