class CreateOrganizations < ActiveRecord::Migration[4.2]
  def change
    create_table :organizations do |t|

      t.integer :account_type, default: 'trial', null: false
      t.integer :max_agents, default: 1
      t.integer :payment_system, default: 'stripe'
      t.integer :agent_session_timeout, default: 30
      t.integer :agent_response_timeout, default: 2

      t.boolean :completed_setup, default: false

      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
