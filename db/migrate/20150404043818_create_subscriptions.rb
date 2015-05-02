class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :organization, index: true, foreign_key: true
      t.string :stripe_id
      t.integer :quantity
      t.timestamp :active_until

      t.timestamps null: false
    end
  end
end
