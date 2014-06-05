class Organization < ActiveRecord::Base
  has_many :agents
  has_many :departments
  has_many :websites
  
  enum payment_system: [:stripe, :paypal]
  enum edition: [:free, :trial, :single, :basic, :pro, :ultimate]
  enum status: [:disabled, :enabled]
end
