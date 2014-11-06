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

  def inactive_visitor_options
    options = {}
    (1..12).each { |count| options["#{pluralize(count, 'minute')}"] = "#{count}" }
    options
  end

  def agent_session_timeouts
    options = {}
    (1..23).each { |count| options["#{pluralize(count, 'hour')}"] = "#{count}" }
    options
  end

  def agent_response_timeouts
    options = {}
    (1..6).each { |count| options["#{pluralize(count, 'minute')}"] = "#{count}" }
    options
  end

  def agent_status
    Agent.where(:organization_id => self.id, :availability => 1).count > 0 ? "online" : "offline"
  end
  
  def process_offline_msg(website_id, name, email, department, message)
  end
end
