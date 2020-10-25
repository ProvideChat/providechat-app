class VisitorArchive
  include Sidekiq::Worker

  def perform
    visitors = Visitor.where("status <> ? AND last_ping < ?", Visitor.statuses[:in_chat], 2.hours.ago)

    visitors.each do |visitor|
      VisitorArchive.create(visitor.attributes).save
    end
  end
end
