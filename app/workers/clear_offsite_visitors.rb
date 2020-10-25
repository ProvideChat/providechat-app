class ClearOffsiteVisitors
  include Sidekiq::Worker

  def perform
    chatting_visitors = Visitor.where("status = ? AND last_ping < ?", Visitor.statuses[:in_chat], 3.minutes.ago)

    chatting_visitors.each do |visitor|
      visitor.chat.status = Chat.statuses[:visitor_timeout]
      visitor.chat.chat_ended = DateTime.now
      visitor.chat.save

      visitor.status = Visitor.statuses[:offsite]
      visitor.chat_id = 0
      visitor.save
    end

    not_chat_statuses = [Visitor.statuses[:no_chat], Visitor.statuses[:waiting_to_chat],
      Visitor.statuses[:agent_ended], Visitor.statuses[:visitor_ended]]
    offsite_visitors = Visitor.where("status in (?) AND last_ping < ?", not_chat_statuses, 1.minute.ago)
    offsite_visitors.each do |visitor|
      visitor.status = Visitor.statuses[:offsite]
      visitor.chat_id = 0
      visitor.save
    end
  end
end
