class Agent < ActiveRecord::Base
  belongs_to :organization
  
  enum account_type: [:agent, :admin, :superadmin]
  enum availability: [:offline, :online]
  enum status: [:disabled, :enabled]
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  mount_uploader :avatar, AvatarUploader
  
  #validates :name, :display_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
end
