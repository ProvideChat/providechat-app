class Website < ActiveRecord::Base
  belongs_to :organization
  has_many :chat_widgets 
  has_many :prechat_forms
  has_many :offline_forms
  has_many :chats
  after_create :create_widget_support
  
  enum status: [:disabled, :enabled]
  
  private
  def create_widget_support
    chat_widget = ChatWidget.new
    offline_form = OfflineForm.new
    prechat_form = PrechatForm.new
    
    chat_widget.organization_id = self.organization_id
    offline_form.organization_id = self.organization_id
    prechat_form.organization_id = self.organization_id
    
    chat_widget.website_id = self.id
    offline_form.website_id = self.id
    prechat_form.website_id = self.id
    
    chat_widget.save
    offline_form.save
    prechat_form.save
  end
end
