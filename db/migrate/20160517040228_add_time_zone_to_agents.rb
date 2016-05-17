class AddTimeZoneToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :time_zone, :string, default: "UTC"
  end
end
