boston = {latitude: "42.3601", longitude: "71.0589", country_code: "US", country_name: "United States",
          city: "Boston", region_code: "MA", region_name: "Massachusetts"}
sf = {latitude: "37.7833", longitude: "122.4167", country_code: "US", country_name: "United States",
          city: "San Francisco", region_code: "CA", region_name: "California"}
austin = {latitude: "30.2500", longitude: "97.7500", country_code: "US", country_name: "United States",
      city: "Austin", region_code: "TX", region_name: "Texas"}
london = {latitude: "51.5072", longitude: "0.1275", country_code: "UK", country_name: "United Kingdom",
          city: "London", region_code: "", region_name: ""}
locations = []
locations.push(boston)
locations.push(sf)
locations.push(austin)
locations.push(london)

browsers = ["Chrome", "Firefox", "Safari", "Opera"]
operating_systems = ["Mac", "Windows", "Linux"]
(1..5).each do 
  location_index = Random.new.rand(0..3)
  browser_index = Random.new.rand(0..3)
  os_index = Random.new.rand(0..2)
  status = 0 #Random.new.rand(0..1)

  visitor = Visitor.create(organization_id: 1, website_id: 3, chat_id: 0, name: "", email: "", 
                 department: "", question: "", smart_invite_status: "", agent_invite_status: 0, 
                 invite_agent_id: 0, last_ping: 10.minutes.from_now, page_views: Random.new.rand(1..5), 
                 current_page: "http://new.providechat.com/", language: "en", 
                 referrer_host: "new.providechat.com", referrer_path: "/", referrer_search: "", 
                 referrer_query: "", search_engine: nil, search_query: nil, 
                 browser_name: browsers[browser_index], browser_version: "45", 
                 operating_system: operating_systems[os_index], 
                 screen_resolution: "1366x768", operator_invite: "", ip_address: "108.180.3.101", 
                 latitude: locations[location_index][:latitude], 
                 longitude: locations[location_index][:longitude], 
                 country_code: locations[location_index][:country_code], 
                 country_name: locations[location_index][:country_name], 
                 city: locations[location_index][:city], 
                 region_code: locations[location_index][:region_code], 
                 region_name: locations[location_index][:region_name], area_code: "0", metro_code: "", 
                 zipcode: "", status: status, browser_fingerprint: "fb145ce60ba99719bf0cd440967598d2")

  if status == 1
    chat = Chat.create(organization_id: 1, website_id: 3, visitor_id: visitor.id, agent_id: 0, status: 0)
    visitor.chat_id = chat.id
    visitor.save
  end
end
