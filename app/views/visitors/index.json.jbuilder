json.array!(@visitors) do |visitor|
  json.extract! visitor, :id, :organization_id, :website_id, :chat_id, :name, :email, :department, :question, :last_ping, :page_views, :current_page, :language, :referrer_host, :referrer_path, :referrer_search, :referrer_query, :search_engine, :search_query, :browser_name, :browser_version, :operating_system, :screen_resolution, :ip_address, :latitude, :longitude, :country_code, :country_name, :city, :region_code, :region_name, :zipcode, :area_code, :metro_code, :status, :status_extended
  if visitor.chat
    json.chat visitor.chat
    json.agent visitor.chat.agent
    json.last_message visitor.chat.last_message(visitor.name)
  end
  json.time_since_created time_ago_in_words(visitor.created_at)
  json.url visitor_url(visitor, format: :json)
end
