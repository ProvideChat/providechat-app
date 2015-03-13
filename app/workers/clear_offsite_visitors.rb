class ClearOffsiteVisitors
  include Sidekiq::Worker

  def perform
    visitors = Visitor.where("status = ? AND last_ping < ?", Visitor.statuses[:in_chat], 5.minutes.ago)

    visitors.each do |visitor|
      visitor.status = Visitor.statuses[:offsite]
      visitor.save
    end
  end
end