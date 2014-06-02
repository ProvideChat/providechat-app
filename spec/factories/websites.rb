# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :website do
    organization_id 1
    url "MyString"
    name "MyString"
    default_department 1
    logo "MyString"
    status "MyString"
  end
end
