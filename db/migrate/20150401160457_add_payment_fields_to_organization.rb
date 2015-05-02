class AddPaymentFieldsToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :trial_days, :integer, :default => 14, :null => false
    add_column :organizations, :trial_period_end, :timestamp
    add_column :organizations, :stripe_customer_id, :string, :default => ''
    remove_column :organizations, :max_agents
  end
end
