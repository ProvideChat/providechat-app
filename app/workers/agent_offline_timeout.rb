class AgentOfflineTimeout
  include Sidekiq::Worker

  def perform
   Agent.where("availability = ? AND last_seen_at < ?", Agent.availability[:online], 2.minutes.ago).update_all(availability: 'offline')
  end
end