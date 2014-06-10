class CreateRapidResponses < ActiveRecord::Migration
  def change
    create_table :rapid_responses do |t|
      t.integer :organization_id
      t.string :name
      t.string :text
      t.integer :order
      t.string :ancestry
      t.string :status

      t.timestamps
    end
    
    add_index :rapid_responses, :organization_id
    add_index :rapid_responses, :ancestry
  end
end
