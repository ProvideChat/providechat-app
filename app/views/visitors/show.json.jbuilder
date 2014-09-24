json.visitor do
  json.(@visitor, :id, :organization_id, :website_id, :name, :email, :department, :question, :last_ping, :page_views, :current_page, :remote_addr, :remote_host, :country, :language, :referrer_host, :referrer_path, :referrer_search, :referrer_query, :search_engine, :search_query, :browser_name, :browser_version, :operating_system, :screen_resolution, :status)
  if @visitor.chat
    json.(@visitor.chat, :status)
  end
end