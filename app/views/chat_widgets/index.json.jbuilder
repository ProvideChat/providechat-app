json.array!(@chat_widgets) do |chat_widget|
  json.extract! chat_widget, :id, :organization_id, :website_id, :online_message, :offline_message, :colour, :display_logo, :display_agent_avatar, :display_mobile_icon
  json.url chat_widget_url(chat_widget, format: :json)
end
