class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.integer :organization_id
      t.string :name
      t.string :email
      t.string :status

      t.timestamps
    end
    
    add_index :departments, :organization_id
  end
end
