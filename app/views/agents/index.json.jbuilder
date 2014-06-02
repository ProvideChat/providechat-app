json.array!(@agents) do |agent|
  json.extract! agent, :id, :name, :display_name, :email, :account_type, :availability, :curr_chats, :max_chats, :active_chat_sound, :background_chat_sound, :visitor_arrived_sound, :avatar, :status
  json.url agent_url(agent, format: :json)
end
