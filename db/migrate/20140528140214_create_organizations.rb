class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :email
      t.boolean :widget_installed
      t.integer :default_department
      t.integer :edition
      t.integer :payment_system

      t.timestamps
    end
  end
end
