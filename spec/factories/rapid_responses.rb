# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rapid_response do
    organization_id 1
    name "MyString"
    text "MyString"
    order 1
    ancestry "MyString"
    status "MyString"
  end
end
