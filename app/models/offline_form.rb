class OfflineForm < ActiveRecord::Base
  belongs_to :website
  before_save :set_defaults
  
  private
    def set_defaults
      self.intro_text = 'Thank you for contacting us!'
      self.name_text = 'Name'
      self.email_text =  'Email'
      self.email_enabled = true
      self.department_text = 'Department'
      self.department_enabled = true
      self.message_text = 'Your message'
      self.button_text = 'Send Message'
      self.success_message = 'Thank you for contacting us. We will get back to you shortly.'
    end
end
