class AddLastSeenAtToAgents < ActiveRecord::Migration[4.2]
  def change
    add_column :agents, :last_seen_at, :datetime
  end
end
