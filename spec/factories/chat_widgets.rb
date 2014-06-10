# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chat_widget do
    organization_id 1
    website_id 1
    online_message "MyString"
    offline_message "MyString"
    colour "MyString"
    display_logo false
    display_agent_avatar false
    display_mobile_icon false
  end
end
