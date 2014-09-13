class Visitor < ActiveRecord::Base
  has_many :chats
  
  
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

    require 'json'
    
    session = JSON.parse(session)
    
    
    # {"api_version":0.4,
    #  "locale":{"country":"us","lang":"en"},
    # "current_session":
    #   {"visits":1,"start":1403707597975,"last_visit":1403707597975,"url":"http://newsite.providechat.dev/","path":"/","referrer":"","referrer_info":{"host":"newsite.providechat.dev","path":"/","protocol":"http:","port":80,"search":"","query":{}},"search":{"engine":null,"query":null}},"original_session":{"visits":646,"start":1394491300924,"last_visit":1403707597976,"url":"http://newsite.providechat.dev/","path":"/","referrer":"","referrer_info":{"host":"newsite.providechat.dev","path":"/","protocol":"http:","port":80,"search":"","query":{}},"search":{"engine":null,"query":null},"prev_visit":1403707444019,"time_since_last_visit":153957},"browser":{"browser":"Chrome","version":29,"os":"Mac"},"plugins":{"flash":true,"silverlight":true,"java":false,"quicktime":true},"time":{"tz_offset":-7,"observes_dst":true},"device":{"screen":{"width":1920,"height":1080},"viewport":{"width":1336,"height":912},"is_tablet":false,"is_phone":false,"is_mobile":false}}

    #Rails.logger.debug "current_session.visits: #{session['current_session']['visits']}"
    
    #remote_addr = session['']
    remote_host = session['current_session']['referrer_info']['host']
    current_page = session['current_session']['url']
    country = session['locale']['country']
    language = session['locale']['lang']
    referrer_host = session['current_session']['referrer_info']['host']
    referrer_path = session['current_session']['referrer_info']['path']
    referrer_search = session['current_session']['referrer_info']['search']
    browser_name = session['browser']['browser']
    browser_version = session['browser']['version']
    operating_system = session['browser']['os']
    screen_resolution = "#{session['device']['screen']['width']}x#{session['device']['screen']['height']}"
        
    website = Website.find_by(:organization_id => org_id, :url => referrer_host)
    
    visitor = Visitor.find_by(:website_id => website.id) || Visitor.new
    
    visitor.organization_id = org_id
    visitor.website_id = website.id
    visitor.country = country
    visitor.current_page = current_page
    visitor.remote_host = remote_host
    visitor.page_views = session['current_session']['visits']
    
    if session['location']['error']
      Rails.logger.debug "No location data"
    end
    
    visitor.save
    
    visitor
  end
end
