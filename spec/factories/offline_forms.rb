# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offline_form do
    organization_id 1
    website_id 1
    intro_text "MyString"
    name_text "MyString"
    email_text ""
    email_enabled false
    department_text "MyString"
    department_enabled false
    message_text "MyString"
    button_text "MyString"
    success_message "MyText"
  end
end
