json.array!(@visitors) do |visitor|
  json.extract! visitor, :id, :organization_id, :website_id, :chat_id, :name, :email, :department, :question, :last_ping, :page_views, :current_page, :remote_addr, :remote_host, :country, :language, :referrer_host, :referrer_path, :referrer_search, :referrer_query, :search_engine, :search_query, :browser_name, :browser_version, :operating_system, :screen_resolution, :status
  if visitor.chat
    json.chat visitor.chat
    json.agent visitor.chat.agent
    json.time_waiting_to_chat time_ago_in_words(visitor.chat.chat_requested, include_seconds: true) if visitor.chat.chat_requested
    json.time_in_chat time_ago_in_words(visitor.chat.chat_accepted, include_seconds: true) if visitor.chat.chat_accepted
    json.time_since_chat time_ago_in_words(visitor.chat.chat_ended, include_seconds: true) if visitor.chat.chat_ended
  end
  json.time_since_created time_ago_in_words(visitor.created_at)
  json.url visitor_url(visitor, format: :json)
end
