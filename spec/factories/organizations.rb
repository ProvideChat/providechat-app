# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "MyString"
    email "MyString"
    widget_installed "MyString"
    default_department 1
    edition "MyString"
    payment_system "MyString"
  end
end
