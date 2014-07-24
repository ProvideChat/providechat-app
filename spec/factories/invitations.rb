# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    organization_id 1
    website_id 1
    invitation_message "MyString"
    smart_invite_enabled false
    smart_invite_mode "MyString"
    invite_pageviews 1
    invite_seconds 1
  end
end
