class ChatMessage < ActiveRecord::Base
  belongs_to :chat

  enum sender: [:visitor, :agent, :system]

  def sent_status(agent)
    sent.in_time_zone(agent.time_zone).strftime('%l:%M %p')
  end
end
