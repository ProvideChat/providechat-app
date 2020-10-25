class AddBrowserFingerprintToVisitors < ActiveRecord::Migration[4.2]
  def change
    add_column :visitors, :browser_fingerprint, :string
    add_index :visitors, :browser_fingerprint
  end
end
