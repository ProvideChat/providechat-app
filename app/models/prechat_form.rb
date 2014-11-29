class PrechatForm < ActiveRecord::Base
  belongs_to :organization
  belongs_to :website
  before_create :set_defaults
  
  def process_update(params, prechat_form_params)
    if params.has_key?(:restore_defaults)
      self.set_defaults
      self.save
      "Your prechat form was reset to defaults."
    elsif params.has_key?(:save_changes)
      self.update(prechat_form_params)
      self.save
      "Your prechat form was successfully updated."
    else
      "Your changes were cancelled"
    end
  end
  
  protected
  
  def set_defaults
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
