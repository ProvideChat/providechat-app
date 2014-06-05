class Website < ActiveRecord::Base
  belongs_to :organization
  
  enum status: [:disabled, :enabled]
end
