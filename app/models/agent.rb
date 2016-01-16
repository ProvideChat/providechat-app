class Agent < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :websites
  has_and_belongs_to_many :departments
  has_many :chats

  enum access_level: [:agent, :admin, :superadmin]
  enum availability: [:offline, :online]
  enum status: [:disabled, :enabled]

  devise :database_authenticatable, :registerable, :confirmable, :async,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable

  mount_uploader :avatar, AvatarUploader

  validates_presence_of :name, presence: true, on: :update, unless: :skip_registation_validations
  validates_presence_of :display_name, presence: true, on: :update, unless: :skip_registation_validations
  validates_presence_of :title, on: :update
  validates :name, length: {maximum: 30}
  validates :display_name, length: {maximum: 20}
  validates :title, length: {maximum: 25}

  attr_accessor :website_url
  attr_accessor :skip_registation_validations

  def password_required?
    super if confirmed?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  # new method to set the password without knowing the current password
  # used in our confirmation controller
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new method to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # new method to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  # only require password if it is being set, but not for new records
  def password_required?
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  def access_level_display
    if self.access_level == 'superadmin'
      "Super Admin"
    else
      self.access_level.capitalize
    end
  end

  def can_edit?(current_agent)
    if self.id == current_agent.id
      true
    elsif self.access_level != 'superadmin' && current_agent.access_level != 'agent'
      true
    else
      false
    end
  end

  def can_delete?(current_agent)
    if self.id != current_agent.id && current_agent.access_level != 'agent' &&
        self.access_level != 'superadmin'
      true
    else
      false
    end
  end

  def self.for_organization(organization_id)
    Agent.where(organization_id: organization_id).order("name ASC")
  end
end
