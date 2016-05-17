class Chat < ActiveRecord::Base
  belongs_to :organization
  belongs_to :agent
  belongs_to :visitor
  belongs_to :website
  belongs_to :department

  has_many :chat_messages

  scope :websites, -> (website_ids) { where website_id: website_ids }
  scope :department, -> (department) { where visitor_department: department }
  scope :agents, -> (agent_ids) { where agent_id: agent_ids }
  scope :from_date, -> (from_date) { where("created_at >= ?", from_date.to_date) }
  scope :to_date, -> (to_date) { where("created_at <= ?", to_date.to_date) }

  before_save :titleize_visitor_name

  enum status: [:not_started, :in_progress, :agent_ended, :visitor_ended,
                :agent_timeout, :visitor_timeout]

  def self.filter_results(organization_id, params)
    chats = Chat.where(organization_id: organization_id).order(created_at: :desc)
    chats = chats.websites(params[:website_ids]) if params[:website_ids].present?
    chats = chats.agents(params[:agent_ids]) if params[:agent_ids].present?
    chats = chats.from_date(params[:from_date]) if params[:from_date].present?
    chats = chats.to_date(params[:to_date]) if params[:to_date].present?

    chats = chats.find(params[:chat_id][6..-1]) if params[:chat_id].present?

    chats
  end

  def ticket_id
    created_at.to_i.to_s[-6, 6] + id.to_s
  end

  def end_chat(reason)
    self.status = reason
    self.chat_ended = DateTime.now
    self.save

    visitor = Visitor.find(self.visitor_id)

    case reason
    when "agent_ended", "visitor_ended"
      visitor.status = reason
    when "agent_timeout"
      visitor.status = "agent_ended"
    when "visitor_timeout"
      visitor.status = "offsite"
    end

    visitor.chat_id = 0
    visitor.save
  end

  def last_message(sender)
    messages = self.chat_messages.where(sender: sender)
    if messages.length > 0
      messages.last.message
    else
      ""
    end
  end

  def chat_accepted_status(agent)
    if chat_accepted 
      chat_accepted.in_time_zone(agent.time_zone).strftime('%b %e/%Y at %l:%M %p')
    else
      "Not accepted (Requested #{chat_requested.in_time_zone(agent.time_zone).strftime('%b %e/%Y at %l:%M %p')})"
    end
  end

  protected

  def titleize_visitor_name
    self.visitor_name = self.visitor_name.titleize
  end
end
