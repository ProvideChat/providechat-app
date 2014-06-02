class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.integer :organization_id
      t.string :url
      t.string :name
      t.integer :default_department
      t.string :logo
      t.string :status

      t.timestamps
    end
  end
end
