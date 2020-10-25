class Invitation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :website
  before_create :set_defaults

  enum invite_mode: [:no_invite, :page_views, :seconds]

  private

  def set_defaults
    self.invitation_message = "Hi there, is there anything I can help you with today? To start chatting, just enter your name and click the button below."
    self.name_text = "Your name"
    self.button_text = "Start chatting"
    self.invite_mode = "page_views"
    self.invite_pageviews = 3
    self.invite_seconds = 15
  end
end
