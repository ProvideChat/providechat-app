# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    widget_installed "MyString"
    edition "MyString"
    payment_system "MyString"
  end
end
