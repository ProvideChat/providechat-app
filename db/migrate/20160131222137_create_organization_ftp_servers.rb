class CreateOrganizationFtpServers < ActiveRecord::Migration
  def change
    create_table :organization_ftp_servers do |t|
      t.references :organization, index: true, foreign_key: true
      t.string :host_address
      t.string :username
      t.string :password
      t.string :directory
      t.integer :status

      t.timestamps null: false
    end
  end
end
