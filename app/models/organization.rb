class Organization < ActiveRecord::Base
  has_many :agents
  has_many :departments
  has_many :websites

  include ActionView::Helpers::TextHelper
  
  enum payment_system: [:stripe, :paypal]
  enum edition: [:free, :trial, :single, :basic, :pro, :ultimate]
  enum status: [:disabled, :enabled]
  
  def inactive_visitor_options
    options = {}
    (1..12).each { |count| options["#{pluralize(count, 'minute')}"] = "#{count}" }
    options
  end
  
  def operator_session_timeouts
    options = {}
    (1..23).each { |count| options["#{pluralize(count, 'hour')}"] = "#{count}" }
    options
  end
  
  def operator_response_timeouts
    options = {}
    (1..6).each { |count| options["#{pluralize(count, 'minute')}"] = "#{count}" }
    options
  end  
end
