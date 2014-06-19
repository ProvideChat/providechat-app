class Department < ActiveRecord::Base
  belongs_to :organization
  has_many :chats
  
  enum status: [:disabled, :enabled]
  
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  
end
