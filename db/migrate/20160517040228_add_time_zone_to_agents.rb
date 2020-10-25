class AddTimeZoneToAgents < ActiveRecord::Migration[4.2]
  def change
    add_column :agents, :time_zone, :string, default: "UTC"
  end
end
