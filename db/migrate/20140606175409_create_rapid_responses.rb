class CreateRapidResponses < ActiveRecord::Migration[4.2]
  def change
    create_table :rapid_responses do |t|
      t.integer :organization_id
      t.integer :website_id, :default => 0
      t.string :name
      t.string :text
      t.integer :order
      t.string :ancestry

      t.timestamps null: false
    end

    add_index :rapid_responses, :organization_id
    add_index :rapid_responses, :website_id
    add_index :rapid_responses, :ancestry
  end
end
