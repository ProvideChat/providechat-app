class Chat < ActiveRecord::Base
  belongs_to :organization
  belongs_to :agent
  belongs_to :visitor
  belongs_to :website
  belongs_to :department

  has_many :chat_messages

  enum status: [:not_started , :in_progress, :agent_ended, :visitor_ended, :agent_timeout, :visitor_timeout]
  
  def end_chat(reason)
    self.status = reason
    self.chat_ended = DateTime.now
    self.save

    visitor = Visitor.find(self.visitor_id)
    visitor.status = 'chat_ended'
    visitor.save
  end
end
