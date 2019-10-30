# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :agent do
    name  { "MyString" }
    display_name { "MyString" }
    email { "MyString" }
    account_type { "superadmin" }
    availability { "online" }
    active_chat_sound { "MyString" }
    background_chat_sound { "MyString" }
    visitor_arrived_sound { "MyString" }
    avatar { "MyString" }
    status { "enabled" }
  end
end
