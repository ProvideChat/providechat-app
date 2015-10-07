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
    chats = Chat.where(organization_id: organization_id)
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
    if self.status == 'in_progress' || self.status == 'agent_ended' || self.status == 'visitor_ended'
      self.status = reason
      self.chat_ended = DateTime.now
      self.save

      visitor = Visitor.find(self.visitor_id)
      visitor.status = reason
      visitor.save
    end
  end

  def last_message(sender)
    messages = self.chat_messages.where(sender: sender)
    if messages.length > 0
      messages.last.message
    else
      ""
    end
  end

  def email_transcript(transcript_email)
    require 'mandrill'

    text_msg = "Hello #{self.visitor_name},\n\n"
    text_msg += "Here if your requested chat transcript\n\n"
    self.chat_messages.each do |chat_message|
      text_msg += " - #{chat_message.user_name}: #{chat_message.message}\n\n"
    end

    html_msg = "<html><h3>Hello #{self.visitor_name}</h3><p>Here is your requested chat transcript</p><hr>"
    last_user_name = ""
    self.chat_messages.each do |chat_message|
      if chat_message.user_name != last_user_name
        html_msg += "<br><strong>#{chat_message.user_name}:</strong><br>"
      end
      html_msg += "#{chat_message.message}<br>"
      last_user_name = chat_message.user_name
    end
    html_msg += "<hr><p>Thanks for using Provide Chat! "
    html_msg += "Learn more at <a href='http://providechat.com'>providechat.com</a></p></html>"

    m = Mandrill::API.new
    message = {
      subject: "Your chat with #{self.website.name} - Ticket ID: #{self.ticket_id}",
      from_name: "Provide Chat",
      text: text_msg,
      to: [{
        email: transcript_email,
        name: self.visitor_name
      }],
      html: html_msg,
      from_email: "info@providechat.com"
    }
    m.messages.send message
  end

  protected

  def titleize_visitor_name
    self.visitor_name = self.visitor_name.titleize
  end
end
