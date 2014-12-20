class Website < ActiveRecord::Base
  belongs_to :organization
  has_many :chat_widgets
  has_many :prechat_forms
  has_many :offline_forms
  has_many :invitations
  has_many :chats
  has_many :rapid_responses
  has_many :visitors
  has_and_belongs_to_many :agents
  has_and_belongs_to_many :departments

  after_create :create_widget_support
  before_validation :smart_url_update

  mount_uploader :logo, LogoUploader

  validates :name, :url, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :url, scope: :organization_id

  def widget_status
    if last_ping.nil?
      "Not Installed"
    elsif last_ping > 10.minutes.ago
      "Online"
    else
      "Offline"
    end
  end
  
  protected

  def smart_url_update
    self.url = self.url.sub(/^https?\:\/\//, '').sub(/\/$/, '')
  end

  private
  def create_widget_support
    chat_widget = ChatWidget.new
    offline_form = OfflineForm.new
    prechat_form = PrechatForm.new
    invitation = Invitation.new

    chat_widget.organization_id = self.organization_id
    offline_form.organization_id = self.organization_id
    prechat_form.organization_id = self.organization_id
    invitation.organization_id = self.organization_id

    chat_widget.website_id = self.id
    offline_form.website_id = self.id
    prechat_form.website_id = self.id
    invitation.website_id = self.id

    chat_widget.save
    offline_form.save
    prechat_form.save
    invitation.save
  end
end
