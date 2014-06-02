class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :email
      t.string :widget_installed
      t.integer :default_department
      t.string :edition
      t.string :payment_system

      t.timestamps
    end
  end
end
