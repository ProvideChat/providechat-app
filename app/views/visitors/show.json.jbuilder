json.visitor do
  json.(@visitor, :id, :organization_id, :website_id, :name, :email, :department, :question, :last_ping, :page_views, :current_page, :language, :referrer_host, :referrer_path, :referrer_search, :referrer_query, :search_engine, :search_query, :browser_name, :browser_version, :browser_image, :operating_system, :os_image, :screen_resolution, :ip_address, :latitude, :longitude, :country_code, :country_name, :city, :region_code, :region_name, :zipcode, :area_code, :metro_code, :status, :status_extended)
  if @visitor.chat
    json.chat @visitor.chat
    json.agent @visitor.chat.agent
    json.last_message @visitor.chat.last_message(@visitor.id)
    json.time_waiting_to_chat time_ago_in_words(@visitor.chat.chat_requested, include_seconds: true) if @visitor.chat.chat_requested
    json.time_in_chat time_ago_in_words(@visitor.chat.chat_accepted, include_seconds: true) if @visitor.chat.chat_accepted
    json.time_since_chat time_ago_in_words(@visitor.chat.chat_ended, include_seconds: true) if @visitor.chat.chat_ended
  end
  json.time_since_created time_ago_in_words(@visitor.created_at)
end
