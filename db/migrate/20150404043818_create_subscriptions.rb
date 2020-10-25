class CreateSubscriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :subscriptions do |t|
      t.references :organization, index: true, foreign_key: true
      t.string :stripe_id, null: false
      t.integer :quantity, default: 1, null: false
      t.timestamp :active_until
      t.string :plan_id
      t.string :interval
      t.integer :amount
      t.string :coupon
      t.timestamp :current_period_end
      t.timestamp :current_period_start
      t.timestamp :billing_start

      t.timestamps null: false
    end
  end
end
