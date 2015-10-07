class OfflineForm < ActiveRecord::Base
  belongs_to :organization
  belongs_to :website
  before_create :set_defaults

  def process_update(params, offline_form_params)
    if params.key?(:restore_defaults)
      self.set_defaults
      self.save
      "Your offline form was reset to defaults."
    elsif params.key?(:save_changes)
      self.update(offline_form_params)
      self.save
      "Your offline form was successfully updated."
    else
      "Your changes were cancelled"
    end
  end

  protected

  def set_defaults
    self.intro_text = "We're sorry we're unavailable to chat at the moment. Please send us a message and we will get back to you shortly."
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
