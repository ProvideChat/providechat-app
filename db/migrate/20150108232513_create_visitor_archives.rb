class CreateVisitorArchives < ActiveRecord::Migration[4.2]
  def change
    create_table :visitor_archives do |t|
      t.integer :organization_id
      t.integer :website_id, :default => 0
      t.integer :chat_id, :default => 0
      t.string :name, :default => ''
      t.string :email, :default => ''
      t.string :department, :default => ''
      t.string :question, :default => ''
      t.timestamp :last_ping
      t.integer :page_views, :default => 0
      t.string :current_page, :default => ''
      t.string :language, :default => ''
      t.string :referrer_host, :default => ''
      t.string :referrer_path, :default => ''
      t.string :referrer_search, :default => ''
      t.string :referrer_query, :default => ''
      t.string :search_engine, :default => ''
      t.string :search_query, :default => ''
      t.string :browser_name, :default => ''
      t.string :browser_version, :default => ''
      t.string :operating_system, :default => ''
      t.string :screen_resolution, :default => ''
      t.string :smart_invite_status, :default => ''
      t.string :operator_invite, :default => ''
      t.string :ip_address, :default => ''
      t.string :latitude, :default => ''
      t.string :longitude, :default => ''
      t.string :country_code, :default => ''
      t.string :country_name, :default => ''
      t.string :city, :default => ''
      t.string :region_code, :default => ''
      t.string :region_name, :default => ''
      t.string :area_code, :default => ''
      t.string :metro_code, :default => ''
      t.string :zipcode, :default => ''
      t.integer :status

      t.timestamps null: false
    end

    add_index :visitor_archives, :organization_id
  end
end
