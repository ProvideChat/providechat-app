class Organization < ActiveRecord::Base
  has_many :agents
  has_many :departments
  
end
