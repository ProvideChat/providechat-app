class Visitor < ActiveRecord::Base
  has_one :chat
  has_one :website

  enum status: [:no_chat, :waiting_to_chat, :in_chat, :chat_ended, :offsite]

#  t.integer  "organization_id"
#  t.integer  "website_id"
#  t.string   "name"
#  t.string   "email"
#  t.string   "department"
#  t.string   "question"
#  t.datetime "last_ping"
#  t.integer  "page_views"
#  t.string   "current_page"
#  t.string   "remote_addr"
#  t.string   "remote_host"
#  t.string   "country"
#  t.string   "language"
#  t.string   "referrer_host"
#  t.string   "referrer_path"
#  t.string   "referrer_search"
#  t.string   "referrer_query"
#  t.string   "search_engine"
#  t.string   "search_query"
#  t.string   "browser_name"
#  t.string   "browser_version"
#  t.string   "operating_system"
#  t.string   "screen_resolution"
#  t.string   "smart_invite_status"
#  t.string   "operator_invite"
#  t.string   "status"

  def self.process_session (org_id, session)

    # {"api_version":0.4,
    #  "locale":{"country":"us","lang":"en"},
    # "current_session":
    #  SESSION DETAILS: {"api_version"=>0.4, "locale"=>{"country"=>"us", "lang"=>"en"}, "current_session"=>{"visits"=>1, "start"=>1411186442747, "last_visit"=>1411186442747, "url"=>"http://new.providechat.dev/", "path"=>"/", "referrer"=>"", "referrer_info"=>{"host"=>"new.providechat.dev", "path"=>"/", "protocol"=>"http:", "port"=>80, "search"=>"", "query"=>{}}, "search"=>{"engine"=>nil, "query"=>nil}}, "original_session"=>{"visits"=>16, "start"=>1411184787036, "last_visit"=>1411186442748, "url"=>"http://new.providechat.dev/", "path"=>"/", "referrer"=>"", "referrer_info"=>{"host"=>"new.providechat.dev", "path"=>"/", "protocol"=>"http:", "port"=>80, "search"=>"", "query"=>{}}, "search"=>{"engine"=>nil, "query"=>nil}, "prev_visit"=>1411186343610, "time_since_last_visit"=>99138}, "browser"=>{"browser"=>"Chrome", "version"=>37, "os"=>"Mac"}, "plugins"=>{"flash"=>true, "silverlight"=>true, "java"=>false, "quicktime"=>true}, "time"=>{"tz_offset"=>-7, "observes_dst"=>true}, "device"=>{"screen"=>{"width"=>1366, "height"=>768}, "viewport"=>{"width"=>1175, "height"=>669}, "is_tablet"=>false, "is_phone"=>false, "is_mobile"=>false}, "location"=>{"error"=>true, "source"=>"google"}}

    #Rails.logger.debug "current_session.visits: #{session['current_session']['visits']}"

    #remote_addr = session['']
    current_visits = session['current_session']['visits']
    total_visits = session['original_session']['visits']
    #remote_host = session['current_session']['referrer_info']['host']
    current_page = session['current_session']['url']
    #country = session['locale']['country']
    language = session['locale']['lang']
    referrer_host = session['current_session']['referrer_info']['host']
    referrer_path = session['current_session']['referrer_info']['path']
    referrer_search = session['current_session']['referrer_info']['search']
    #referrer_query = session['current_session']['referrer_info']['query']

    ip_address = session['location']['ip']
    latitude = session['location']['latitude']
    longitude = session['location']['longitude']
    country_code = session['location']['country_code']
    country_name = session['location']['country_name']
    city = session['location']['city']
    region_code = session['location']['region_code']
    region_name = session['location']['region_name']
    zipcode = session['location']['zipcode']
    area_code = session['location']['area_code']
    metro_code = session['location']['metro_code']

    search_engine = session['current_session']['search']['engine']
    search_query = session['current_session']['search']['query']

    browser_name = session['browser']['browser']
    browser_version = session['browser']['version']
    operating_system = session['browser']['os']
    screen_resolution = "#{session['device']['screen']['width']}x#{session['device']['screen']['height']}"

    Rails.logger.debug "referrer_host: #{referrer_host}"
    website = Website.find_by(:organization_id => org_id, :url => referrer_host)

    if website
      visitor = Visitor.find_by(:website_id => website.id, :browser_name => browser_name) || Visitor.new

      visitor.organization_id = org_id
      visitor.website_id = website.id
      #visitor.country = country
      visitor.current_page = current_page
      #visitor.remote_host = remote_host
      visitor.page_views = current_visits

      visitor.language = language
      visitor.referrer_host = referrer_host
      visitor.referrer_path = referrer_path
      visitor.referrer_search = referrer_search
      #visitor.referrer_query = referrer_query

      visitor.search_engine = search_engine
      visitor.search_query = search_query

      visitor.browser_name = browser_name
      visitor.browser_version = browser_version
      visitor.operating_system = operating_system
      visitor.screen_resolution = screen_resolution

      visitor.ip_address = ip_address
      visitor.latitude = latitude
      visitor.longitude = longitude
      visitor.country_code = country_code
      visitor.country_name = country_name
      visitor.city = city
      visitor.region_code = region_code
      visitor.region_name = region_name
      visitor.zipcode = zipcode
      visitor.area_code = area_code
      visitor.metro_code = metro_code

      if session['location']['error']
        Rails.logger.debug "No location data"
      end
      visitor.status = 'no_chat'

      visitor.save

      visitor
    else
      false
    end
  end
end
