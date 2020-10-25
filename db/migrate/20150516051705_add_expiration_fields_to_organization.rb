class AddExpirationFieldsToOrganization < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :expiration_date, :timestamp
    add_column :organizations, :date_reminded, :timestamp
  end
end
