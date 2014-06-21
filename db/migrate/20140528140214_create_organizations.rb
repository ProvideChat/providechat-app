class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :email
      t.integer :max_agents
      t.integer :payment_system
      t.integer :inactive_visitor_removal
      t.integer :agent_session_timeout
      t.integer :agent_response_timeout

      t.timestamps
    end
  end
end
