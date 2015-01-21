class Chat < ActiveRecord::Base
  belongs_to :organization
  belongs_to :agent
  belongs_to :visitor
  belongs_to :website
  belongs_to :department

  has_many :chat_messages

  before_save :titleize_visitor_name

  enum status: [:not_started , :in_progress, :agent_ended, :visitor_ended, :agent_timeout, :visitor_timeout]

  def end_chat(reason)
    self.status = reason
    self.chat_ended = DateTime.now
    self.save

    visitor = Visitor.find(self.visitor_id)
    visitor.status = 'chat_ended'
    visitor.save
  end

  def email_transcript(transcript_email)
    require 'mandrill'

    text_msg = %q{Hello #{self.visitor_name},\n\n
      Here if your requested chat transcript\n\n
    }
    self.chat_messages.each do |chat_message|
      text_msg = text_msg + " - #{chat_message.user_name}: #{chat_message.message}\n\n"
    end

    html_msg = %q{<html><h3>Hello #{self.visitor_name}</h3><p>Here is your requested chat transcript</p><ul>}
    self.chat_messages.each do |chat_message|
      html_msg = html_msg + "<li><strong>#{chat_message.user_name}:</strong> #{chat_message.message}"
    end
    html_msg = html_msg + "</ul><hr></html>"

    m = Mandrill::API.new
    message = {
     :subject=> "Your Provide Chat Transcript",
     :from_name=> "Provide Chat",
     :text=> text_msg,
     :to=>[
       {
         :email=> transcript_email,
         :name=> self.visitor_name
       }
     ],
     :html=> html_msg,
     :from_email=>"info@providechat.com"
    }
    sending = m.messages.send message
  end

  protected

  def titleize_visitor_name
    self.visitor_name = self.visitor_name.titleize
  end
end
