class PrechatForm < ActiveRecord::Base
  belongs_to :organization
  belongs_to :website
  before_create :set_defaults
  
  private
    def set_defaults
      self.enabled = true
      self.intro_text = 'Thank you for contacting us!'
      self.name_text = 'Name'
      self.email_text =  'Email'
      self.email_enabled = true
      self.department_text = 'Department'
      self.department_enabled = true
      self.message_text = 'Initial Question'
      self.button_text = 'Start Chat'
    end
end
