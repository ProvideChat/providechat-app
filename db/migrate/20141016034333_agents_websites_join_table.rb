class AgentsWebsitesJoinTable < ActiveRecord::Migration[4.2]
  def change
    create_join_table :agents, :websites do |t|
      t.index [:agent_id, :website_id]
      # t.index [:website_id, :agent_id]
    end
  end
end
