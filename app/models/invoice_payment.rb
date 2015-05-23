class InvoicePayment < ActiveRecord::Base
  belongs_to :organization
  belongs_to :subscription
end
