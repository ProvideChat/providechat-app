class AddSetupStepToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :setup_step, :integer, default: 0
  end
end
