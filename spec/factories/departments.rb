# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :department do
    organization_id 1
    name "MyString"
    email "MyString"
    status "MyString"
  end
end
