class Visitor < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  has_one :chat
  belongs_to :organization
  belongs_to :website

  enum smart_invite_status: [:not_seen, :seen_popup]
  enum agent_invite_status: [:not_sent, :agent_sent, :visitor_seen]

  enum status: [:no_chat, :waiting_to_chat, :in_chat, :agent_ended, :visitor_ended, :offsite]

  before_save :titleize_name

  def self.current_visitors(current_agent)
    active = [ Visitor.statuses[:no_chat], Visitor.statuses[:waiting_to_chat], Visitor.statuses[:in_chat]]
    Visitor.where("organization_id = ? AND status IN (?) AND last_ping > ?", current_agent.organization_id, active, 2.minutes.ago)
  end

  def process_invitation
    self.smart_invite_status = :seen_popup
    self.agent_invite_status = :visitor_seen
    self.save
  end

  def invite_sent
    self.agent_invite_status == 'agent_sent' ? true : false
  end

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

  def self.process_session (org_id, website, session)

    # {"api_version":0.4,
    #  "locale":{"country":"us","lang":"en"},
    # "current_session":
    #  SESSION DETAILS: {"api_version"=>0.4, "locale"=>{"country"=>"us", "lang"=>"en"}, "current_session"=>{"visits"=>1, "start"=>1411186442747, "last_visit"=>1411186442747, "url"=>"http://new.providechat.dev/", "path"=>"/", "referrer"=>"", "referrer_info"=>{"host"=>"new.providechat.dev", "path"=>"/", "protocol"=>"http:", "port"=>80, "search"=>"", "query"=>{}}, "search"=>{"engine"=>nil, "query"=>nil}}, "original_session"=>{"visits"=>16, "start"=>1411184787036, "last_visit"=>1411186442748, "url"=>"http://new.providechat.dev/", "path"=>"/", "referrer"=>"", "referrer_info"=>{"host"=>"new.providechat.dev", "path"=>"/", "protocol"=>"http:", "port"=>80, "search"=>"", "query"=>{}}, "search"=>{"engine"=>nil, "query"=>nil}, "prev_visit"=>1411186343610, "time_since_last_visit"=>99138}, "browser"=>{"browser"=>"Chrome", "version"=>37, "os"=>"Mac"}, "plugins"=>{"flash"=>true, "silverlight"=>true, "java"=>false, "quicktime"=>true}, "time"=>{"tz_offset"=>-7, "observes_dst"=>true}, "device"=>{"screen"=>{"width"=>1366, "height"=>768}, "viewport"=>{"width"=>1175, "height"=>669}, "is_tablet"=>false, "is_phone"=>false, "is_mobile"=>false}, "location"=>{"error"=>true, "source"=>"google"}}

    # {"api_version"=>0.4,
    #  "locale"=>{"country"=>"us", "lang"=>"en"},
    #  "current_session"=>{"visits"=>1, "start"=>1420524239616, "last_visit"=>1420524239616, "url"=>"http://new.providechat.dev/", "path"=>"/", "referrer"=>"", "referrer_info"=>{"host"=>"new.providechat.dev", "path"=>"/", "protocol"=>"http:", "port"=>80, "search"=>"", "query"=>{}}, "search"=>{"engine"=>nil, "query"=>nil}},
    #  "original_session"=>{"visits"=>8, "start"=>1419659348660, "last_visit"=>1420524239617, "url"=>"http://new.providechat.dev/", "path"=>"/", "referrer"=>"", "referrer_info"=>{"host"=>"new.providechat.dev", "path"=>"/", "protocol"=>"http:", "port"=>80, "search"=>"", "query"=>{}}, "search"=>{"engine"=>nil, "query"=>nil}, "prev_visit"=>1420524215699, "time_since_last_visit"=>23918},
    #  "browser"=>{"browser"=>"Chrome", "version"=>39, "os"=>"Mac"},
    #  "plugins"=>{"flash"=>true, "silverlight"=>false, "java"=>true, "quicktime"=>false},
    #  "time"=>{"tz_offset"=>-8, "observes_dst"=>true},
    #  "device"=>{"screen"=>{"width"=>1920, "height"=>1080}, "viewport"=>{"width"=>1474, "height"=>941}, "is_tablet"=>false, "is_phone"=>false, "is_mobile"=>false},
    # "location"=>{"longitude"=>-123.1333, "latitude"=>49.25, "asn"=>"AS852", "offset"=>"-7", "ip"=>"154.20.236.47", "area_code"=>"0", "continent_code"=>"NA", "dma_code"=>"0", "city"=>"Vancouver", "timezone"=>"America/Vancouver", "region"=>"British Columbia", "country_code"=>"CA", "isp"=>"TELUS Communications Inc.", "country"=>"Canada", "country_code3"=>"CAN", "region_code"=>"BC"}, "location_provider"=>"Telize"}

    #Rails.logger.debug "current_session.visits: #{session['current_session']['visits']}"
    Rails.logger.info session

    #remote_addr = session['']
    current_visits = session['current_session']['visits']
    #total_visits = session['original_session']['visits']
    #remote_host = session['current_session']['referrer_info']['host']
    current_page = session['current_session']['url']
    website_url = URI.parse(current_page).host
    #country = session['locale']['country']
    language = session['locale']['lang']
    referrer_host = session['current_session']['referrer_info']['host']
    referrer_path = session['current_session']['referrer_info']['path']
    referrer_search = session['current_session']['referrer_info']['search']
    #referrer_query = session['current_session']['referrer_info']['query']

    # IP Info

    ip_address = session['location']['ip']
    latitude = session['location']['latitude']
    longitude = session['location']['longitude']
    country_code = session['location']['country_code']

    country_name = ''
    if session['location_provider'] == 'Telize'
      country_name = session['location']['country']
    elsif session['location_provider'] == 'FreeGeoIP'
      country_name = session['location']['country_name']
    end

    area_code = session['location']['area_code']

    city, region_name, region_name, zipcode, metro_code = "", "", "", "", ""
    if session['location_provider'] == 'FreeGeoIP'
      city = session['location']['city']
      region_code = session['location']['region_code']
      region_name = session['location']['region_name']
      zipcode = session['location']['zipcode']
      metro_code = session['location']['metro_code']
    elsif session['location_provider'] == 'Telize'
      city = session['location']['city']
      region_code = session['location']['region_code']
      region_name = session['location']['region']
    end

    search_engine = session['current_session']['search']['engine']
    search_query = session['current_session']['search']['query']
    plugins = session["plugins"].to_s

    browser_name = session['browser']['browser']
    browser_version = session['browser']['version']
    operating_system = session['browser']['os']
    screen_resolution = "#{session['device']['screen']['width']}x#{session['device']['screen']['height']}"

    Rails.logger.info "referrer_host: #{referrer_host}"
    # website = Website.find(:organization_id => org_id, :url => website_url)

    browser_fingerprint = Digest::MD5.hexdigest("#{ip_address.to_s}#{browser_name}#{browser_version.to_s}#{operating_system}#{screen_resolution}#{plugins}")

    statuses = [ Visitor.statuses[:no_chat], Visitor.statuses[:waiting_to_chat], Visitor.statuses[:in_chat], Visitor.statuses[:agent_ended]]
    # visitor = Visitor.find_by(:website_id => website.id, :browser_name => browser_name,
    #                          :browser_version => browser_version.to_s, :operating_system => operating_system,
    #                          :ip_address => ip_address, status: statuses) || Visitor.new
    visitor = Visitor.find_by(website_id: website.id, browser_fingerprint: browser_fingerprint, status: statuses) || Visitor.new

    visitor.organization_id = org_id
    visitor.website_id = website.id
    visitor.browser_fingerprint = browser_fingerprint
    # visitor.country = country
    if (visitor.current_page != current_page)
      visitor.current_page = current_page
      visitor.page_views = visitor.page_views + 1
    end
    # visitor.remote_host = remote_host
    # visitor.page_views = current_visits

    visitor.language = language
    visitor.referrer_host = referrer_host
    visitor.referrer_path = referrer_path
    visitor.referrer_search = referrer_search
    #visitor.referrer_query = referrer_query

    visitor.search_engine = search_engine
    visitor.search_query = search_query

    visitor.browser_name = browser_name
    visitor.browser_version = browser_version.to_s
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

    Rails.logger.debug "No location data" if session['location']['error']

    visitor.status = 'no_chat' if visitor.new_record?

    visitor.last_ping = DateTime.now
    visitor.save

    visitor
  end

  def browser_image
    case self.browser_name
    when "Chrome"
      "/images/browsers/chrome.png"
    when "Safari"
      "/images/browsers/safari.png"
    when "Konqueror"
      "/images/browsers/konqueror.png"
    when "Firefox", "Netscape", "Mozilla"
      "/images/browsers/firefox.png"
    when "Explorer", "MSIE"
      "/images/browsers/internet-explorer.png"
    else
      "/images/browsers/web.png"
    end
  end

  def os_image
    case self.operating_system
    when "Windows"
      "/images/os/windows.png"
    when "Mac"
      "/images/os/apple.png"
    when "iPhone/iPod", "iPad"
      "/images/os/ios.png"
    when "Android"
      "/images/os/android.png"
    when "Linux"
      "/images/os/linux.png"
    else
      ""
    end
  end

  def status_extended
    case self.status
    when "no_chat"
      "Browsing the site"
    when "waiting_to_chat"
      "Waiting for #{time_ago_in_words(self.chat.chat_requested, include_seconds: true)}"
    when "in_chat"
      "Chatting for #{time_ago_in_words(self.chat.chat_accepted, include_seconds: true)}"
    when "chat_ended"
      "Chat ended"
    when "offsite"
      "Visitor has left site"
    end
  end

  protected

  def titleize_name
    self.name = self.name.titleize
  end
end
