class AddBrowserFingerprintToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :browser_fingerprint, :string
    add_index :visitors, :browser_fingerprint
  end
end
