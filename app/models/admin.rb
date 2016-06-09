class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable, :async, :recoverable, :validatable
  devise :database_authenticatable, :rememberable, :trackable, :async
end
