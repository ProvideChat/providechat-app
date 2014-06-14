class Department < ActiveRecord::Base
  belongs_to :organization
  has_many :chats
  
  enum status: [:disabled, :enabled]
  
end
