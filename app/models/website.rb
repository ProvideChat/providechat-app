class Website < ActiveRecord::Base
  belongs_to :organization
  has_many :chat_widgets
  has_many :prechat_forms
  has_many :offline_forms
  has_many :invitations
  has_many :chats
  has_many :rapid_responses
  has_many :visitors
  has_many :visitor_archives
  has_many :departments
  has_and_belongs_to_many :agents

  after_create :create_widget_support
  before_validation :smart_url_update

  validates :name, :url, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, format: {with: VALID_EMAIL_REGEX}
  validates_uniqueness_of :name, scope: :organization_id,
                                 message: "'%{value}' has already been assigned to another website. Please enter a unique name."
  validates_uniqueness_of :url, scope: :organization_id,
                                message: "'%{value}' has already been assigned to another website. Please enter a unique URL."

  def update_ping
    self.last_ping = DateTime.now
  end

  def widget_status
    if last_ping.nil?
      "Not Installed"
    elsif last_ping > 10.minutes.ago
      "Online"
    else
      "Offline"
    end
  end

  def assign_to_agents
    Agent.where(organization_id: organization_id).each do |agent|
      agent.websites << self
      agent.save
    end
  end

  protected

  def smart_url_update
    self.url = url.sub(/^https?:\/\//, "").sub(/\/$/, "")
    self.url = url.sub(/\/(?!.*\.).*/, "").sub(/\/$/, "")
  end

  private

  def create_widget_support
    chat_widget = ChatWidget.new
    offline_form = OfflineForm.new
    prechat_form = PrechatForm.new
    invitation = Invitation.new

    chat_widget.organization_id = organization_id
    offline_form.organization_id = organization_id
    prechat_form.organization_id = organization_id
    invitation.organization_id = organization_id

    chat_widget.website_id = id
    offline_form.website_id = id
    prechat_form.website_id = id
    invitation.website_id = id

    chat_widget.save
    offline_form.save
    prechat_form.save
    invitation.save
  end
end
