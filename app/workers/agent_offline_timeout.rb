class AgentOfflineTimeout
  include Sidekiq::Worker

  def perform
    agents = Agent.where("availability = ? AND last_ping < ?", Agent.availability[:online], 2.minutes.ago)

    agents.each do |agent|
      agent.availability = 'offline'
      agent.save
    end
  end
end