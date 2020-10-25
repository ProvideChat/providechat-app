class CreateInvoicePayments < ActiveRecord::Migration[4.2]
  def change
    create_table :invoice_payments do |t|
      t.string :stripe_id, null: false
      t.integer :amount, default: 0, null: false
      t.integer :fee_amount
      t.integer :quantity, default: 1, null: false
      t.string :interval
      t.string :currency
      t.boolean :discount
      t.string :coupon
      t.references :organization, index: true, foreign_key: true
      t.references :subscription, index: true, foreign_key: false

      t.timestamps null: false
    end
  end
end
