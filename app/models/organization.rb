class Organization < ActiveRecord::Base
  has_many :agents
  has_many :departments
  has_many :websites

  validates :agent_session_timeout, numericality: { only_integer: true }
  validates :agent_response_timeout, numericality: { only_integer: true }


  include ActionView::Helpers::TextHelper

  enum payment_system: [:stripe, :paypal]
  enum account_type: [:trial, :paid, :free]
  enum status: [:disabled, :enabled]

  def agent_status
    Agent.where(:organization_id => self.id, :availability => 1).count > 0 ? "online" : "offline"
  end
  
  def process_offline_msg(website_id, name, email, department, message)
  end
end
