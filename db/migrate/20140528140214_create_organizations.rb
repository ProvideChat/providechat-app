class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|

      t.integer :account_type
      t.integer :max_agents
      t.integer :payment_system
      t.integer :agent_session_timeout, :default => 30
      t.integer :agent_response_timeout, :default => 2

      t.boolean :completed_setup

      t.integer :status

      t.timestamps
    end
  end
end
