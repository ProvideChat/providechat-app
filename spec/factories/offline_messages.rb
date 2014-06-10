# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offline_message do
    organization_id 1
    website_id 1
    visitor_id 1
    name "MyString"
    email "MyString"
    department "MyString"
    message "MyText"
  end
end
