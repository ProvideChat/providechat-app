class AddSetupStepToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :setup_step, :integer, default: 0
  end
end
