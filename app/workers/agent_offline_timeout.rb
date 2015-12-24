class AgentOfflineTimeout
  include Sidekiq::Worker

  def perform
    Agent.where("availability = ? AND last_seen_at < ?", Agent.availabilities[:online], 3.minutes.ago).update_all(availability: Agent.availabilities[:offline])
  end
end