class Organization < ActiveRecord::Base
  has_many :agents
  has_many :departments
  has_many :websites
  has_many :offline_messages
  has_many :visitors
  has_many :visitor_archives

  validates :agent_session_timeout, numericality: { only_integer: true, greater_than: 0 }
  validates :agent_response_timeout, numericality: { only_integer: true, greater_than: 0 }

  include ActionView::Helpers::TextHelper

  enum payment_system: [:stripe, :paypal]
  enum account_type: [:trial, :paid, :free]
  enum status: [:disabled, :enabled]

  def self.create_default_organization
    organization = Organization.new
    organization.account_type = 'trial'
    organization.max_agents = 1
    organization.agent_session_timeout = 20
    organization.agent_response_timeout = 2
    organization.status = 'enabled'
    organization.payment_system = 'stripe'
    organization.save

    organization
  end

  def agent_status
    Agent.where(:organization_id => self.id, :availability => 1).count > 0 ? "online" : "offline"
  end

  def process_offline_msg(website_id, name, email, department, message)
  end
end
