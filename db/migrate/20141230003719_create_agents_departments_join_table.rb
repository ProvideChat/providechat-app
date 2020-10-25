class CreateAgentsDepartmentsJoinTable < ActiveRecord::Migration[4.2]
  def change
    create_join_table :agents, :departments do |t|
      t.index [:agent_id, :department_id]
      # t.index [:department_id, :agent_id]
    end
  end
end
