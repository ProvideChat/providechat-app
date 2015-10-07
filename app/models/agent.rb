class Agent < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :websites
  has_and_belongs_to_many :departments
  has_many :chats

  enum access_level: [:agent, :admin, :superadmin]
  enum availability: [:offline, :online]
  enum status: [:disabled, :enabled]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :async,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  validates_presence_of :name, presence: true, length: { maximum: 50 },
                               on: :update
  validates_presence_of :title, on: :update
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  def access_level_display
    if self.access_level == 'superadmin'
      "Super Admin"
    else
      self.access_level.capitalize
    end
  end
end
