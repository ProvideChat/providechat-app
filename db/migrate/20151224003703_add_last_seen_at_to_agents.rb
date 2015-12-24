class AddLastSeenAtToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :last_seen_at, :datetime
  end
end
