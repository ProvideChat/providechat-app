class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :email

      t.integer :account_type
      t.integer :max_agents
      t.integer :payment_system
      t.integer :agent_session_timeout
      t.integer :agent_response_timeout

      t.boolean :completed_setup

      t.integer :status

      t.timestamps
    end
  end
end
