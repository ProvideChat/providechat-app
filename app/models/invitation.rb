class Invitation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :website
  before_create :set_defaults
  
  private
    def set_defaults
      self.invitation_message = "Hi there, I'm %name%, is there anything I can help you with today?"
      self.smart_invite_enabled = false
      self.smart_invite_mode = "pageviews"
      self.invite_pageviews = 3
      self.invite_seconds = 15
    end
end
