class ChatWidget < ActiveRecord::Base
  belongs_to :website
  before_create :set_defaults
  
  private
    def set_defaults
      self.online_message = 'Chat Now'
      self.offline_message = 'Send A Message'
      self.title_message = 'Welcome to Provide Chat'
      self.color = '#3B3B3B'
      self.display_logo = true
      self.display_agent_avatar = true
      self.display_mobile_icon = true
    end
end
