json.array!(@visitors) do |visitor|
  json.extract! visitor, :id, :organization_id, :website_id, :name, :email, :department, :question, :last_ping, :page_views, :current_page, :remote_addr, :remote_host, :country, :language, :referrer_host, :referrer_path, :referrer_search, :referrer_query, :search_engine, :search_query, :browser_name, :browser_version, :operating_system, :screen_resolution, :status
  json.url visitor_url(visitor, format: :json)
end
