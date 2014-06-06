class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.integer :organization_id
      t.integer :website_id
      t.string :name
      t.string :email
      t.string :department
      t.string :question
      t.timestamp :last_ping
      t.integer :page_views
      t.string :current_page
      t.string :remote_addr
      t.string :remote_host
      t.string :country
      t.string :language
      t.string :referrer_host
      t.string :referrer_path
      t.string :referrer_search
      t.string :referrer_query
      t.string :search_engine
      t.string :search_query
      t.string :browser_name
      t.string :browser_version
      t.string :operating_system
      t.string :screen_resolution
      t.string :smart_invite_status
      t.string :operator_invite
      t.string :status

      t.timestamps
    end
  end
end
