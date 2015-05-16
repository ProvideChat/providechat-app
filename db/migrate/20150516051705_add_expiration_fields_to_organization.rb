class AddExpirationFieldsToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :expiration_date, :timestamp
    add_column :organizations, :date_reminded, :timestamp
  end
end
