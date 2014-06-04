class Department < ActiveRecord::Base
  belongs_to :organization
  
  enum status: [:enabled, :disabled]
  
end
