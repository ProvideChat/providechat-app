class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :email
      t.integer :edition
      t.integer :payment_system
      t.integer :inactive_visitor_removal
      t.integer :operator_session_timeout
      t.integer :operator_response_timeout

      t.timestamps
    end
  end
end
