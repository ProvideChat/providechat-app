# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :visitor do
    organization_id 1
    website_id 1
    name "MyString"
    email "MyString"
    department "MyString"
    question "MyString"
    page_views 1
    current_page "MyString"
    remote_addr "MyString"
    remote_host "MyString"
    country "MyString"
    language "MyString"
    referrer_host "MyString"
    referrer_path "MyString"
    referrer_search "MyString"
    referrer_query "MyString"
    search_engine "MyString"
    search_query "MyString"
    browser_name "MyString"
    browser_version "MyString"
    operating_system "MyString"
    screen_resolution "MyString"
    smart_invite_status "MyString"
    operator_invite "MyString"
    status "MyString"
  end
end
