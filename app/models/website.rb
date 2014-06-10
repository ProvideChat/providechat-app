class Website < ActiveRecord::Base
  belongs_to :organization
  has_many :chat_widgets 
  has_many :prechat_forms
  has_many :offline_forms
  after_create :create_widget_support
  
  enum status: [:disabled, :enabled]
  
  private
  def create_widget_support
    chat_widget = ChatWidget.new
    offline_message = OfflineMessage.new
    prechat_survey = PrechatSurvey.new
    
    chat_widget.organization_id = self.organization_id
    offline_message.organization_id = self.organization_id
    prechat_survey.organization_id = self.organization_id
    
    chat_widget.website_id = self.website_id
    offline_message.website_id = self.website_id
    prechat_survey.website_id = self.website_id
    
    chat_widget.save
    offline_message.save
    prechat_survey.save
  end
end
