class DepartmentsWebsitesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :departments, :websites do |t|
      t.index [:department_id, :website_id]
      # t.index [:website_id, :department_id]
    end
  end
end
