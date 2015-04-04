class AddPaymentFieldsToOrganization < ActiveRecord::Migration
  def change
    t.integer :trial_days, :default => 14, :null => false
    t.timestamp :trial_ends, null: false
    t.timestamp :billing_start, null: false
    t.integer :agent_subscription, :default => 0
    t.string :stripe_customer_id
  end
end
