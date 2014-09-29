# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chat_message do
    chat_id 1
    user_name "MyString"
    sender "MyString"
    type ""
    sent "2014-09-28 21:28:59"
    seen_by_agent false
    seen_by_visitor false
    message "MyText"
  end
end
