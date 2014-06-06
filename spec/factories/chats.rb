# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chat do
    organization_id 1
    website_id 1
    visitor_id 1
    operator_id 1
    operator_typing "MyString"
    visitor_typing "MyString"
    chat_requested "2014-06-05 17:01:29"
    chat_accepted "2014-06-05 17:01:29"
    chat_ended "2014-06-05 17:01:29"
    visitor_name "MyString"
    visitor_email "MyString"
    visitor_department "MyString"
    visitor_question "MyString"
    status "MyString"
  end
end
