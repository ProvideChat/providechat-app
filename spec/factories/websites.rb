# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :website do
    organization_id 1
    url "MyString"
    name "MyString"
    email "support@providechat.com"
    logo "MyString"
  end
end
