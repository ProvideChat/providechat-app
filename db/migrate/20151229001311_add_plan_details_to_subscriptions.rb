class AddPlanDetailsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :plan_id, :string
    add_column :subscriptions, :interval, :string
    add_column :subscriptions, :amount, :integer
    add_column :subscriptions, :current_period_end, :timestamp
    add_column :subscriptions, :current_period_start, :timestamp
  end
end
