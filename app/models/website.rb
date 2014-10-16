class Website < ActiveRecord::Base
  belongs_to :organization
  has_many :chat_widgets
  has_many :prechat_forms
  has_many :offline_forms
  has_many :invitations
  has_many :chats
  has_and_belongs_to_many :agents
  has_and_belongs_to_many :departments

  after_create :create_widget_support

  mount_uploader :logo, LogoUploader

  enum status: [:disabled, :enabled]

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
