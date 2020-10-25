class CreateOrganizationFtpServers < ActiveRecord::Migration[4.2]
  def change
    create_table :organization_ftp_servers do |t|
      t.references :organization, index: true, foreign_key: true
      t.string :host_address
      t.string :username
      t.string :password
      t.string :directory
      t.text :comments
      t.integer :status

      t.timestamps null: false
    end
  end
end
