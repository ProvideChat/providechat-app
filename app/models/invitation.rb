class Invitation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :website
  before_create :set_defaults
  
  enum invite_mode: [:disabled, :page_views, :seconds]
  
  private
    def set_defaults
      self.invitation_message = "Hi there, I'm %name%, is there anything I can help you with today?"
      self.invite_mode = "disabled"
      self.invite_pageviews = 3
      self.invite_seconds = 15
    end
end
