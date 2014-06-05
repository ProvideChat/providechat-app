class Agent < ActiveRecord::Base
  belongs_to :organization
  
  enum account_type: [:operator, :admin, :superadmin]
  enum availability: [:offline, :online]
  enum status: [:disabled, :enabled]
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  mount_uploader :avatar, AvatarUploader
end
