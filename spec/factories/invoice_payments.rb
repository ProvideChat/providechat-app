FactoryGirl.define do
  factory :invoice_payment do
    stripe_id "MyString"
amount 1
fee_account_integer "MyString"
organization nil
subscription nil
  end

end
