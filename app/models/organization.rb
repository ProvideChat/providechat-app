class Organization < ActiveRecord::Base
  has_many :agents
  has_many :departments
  has_many :websites
  has_many :offline_messages
  has_many :visitors
  has_many :visitor_archives
  has_one :subscription

  validates :agent_session_timeout, numericality: { only_integer: true, greater_than: 0 }
  validates :agent_response_timeout, numericality: { only_integer: true, greater_than: 0 }

  include ActionView::Helpers::TextHelper

  enum payment_system: [:stripe, :paypal]
  enum account_type: [:trial, :paid, :free]
  enum status: [:disabled, :enabled]

  def validate_widget_website(http_referrer)

    require 'uri'
    uri = URI(http_referrer)

    logger.info "Validating Widget, HTTP_REFERER: #{http_referrer}"

    website = Website.find_by(organization_id: self.id, url: uri.host)
  end

  def can_create_agents
    case account_type
    when "trial"
      false
    when "free"
      false
    when "paid"
      if self.subscription.quantity && (self.agents.count < self.subscription.quantity)
        true
      else
        false
      end
    end
  end

  def self.create_default_organization
    organization = Organization.new
    organization.account_type = Organization.account_types[:trial]
    organization.agent_session_timeout = 20
    organization.agent_response_timeout = 2
    organization.status = 'enabled'
    organization.payment_system = 'stripe'
    organization.trial_days = 14
    organization.trial_period_end = 14.days.from_now
    organization.completed_setup = false
    organization.setup_step = 1
    organization.save

    organization
  end

  def remaining_trial_days
    if Time.now.to_i < trial_period_end.to_i
      (trial_period_end.to_i - Time.now.to_i) / 1.day + 1
    else
      0
    end
  end

  def agent_status(website_id)
    Website.find(website_id).agents.where(availability: 1).count > 0 ? "online" : "offline"
  end

  def process_offline_msg(website_id, name, email, department, message)
  end

  def self.delete_with_cascade(organization_id)
    organization = Organization.find(organization_id)

    if organization
      Agent.where(organization_id: organization_id).delete_all
      Department.where(organization_id: organization_id).delete_all

      Chat.where(organization_id: organization_id).each do |chat|
        ChatMessage.where(chat_id: chat.id).delete_all
        chat.delete
      end

      Invitation.where(organization_id: organization_id).delete_all
      InvoicePayment.where(organization_id: organization_id).delete_all

      OfflineForm.where(organization_id: organization_id).delete_all
      OfflineMessage.where(organization_id: organization_id).delete_all
      OrganizationFtpServer.where(organization_id: organization_id).delete_all
      PrechatForm.where(organization_id: organization_id).delete_all
      RapidResponse.where(organization_id: organization_id).delete_all
      Subscription.where(organization_id: organization_id).delete_all
      VisitorArchive.where(organization_id: organization_id).delete_all
      Visitor.where(organization_id: organization_id).delete_all
      Website.where(organization_id: organization_id).delete_all

      Organization.delete(organization_id)
    end 
  end
end
