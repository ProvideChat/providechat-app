class AgentMailer < ApplicationMailer
  layout "mailer"

  default from: "noreply@providechat.com"

  def welcome(agent_id)
    @agent = Agent.find(agent_id)

    mail(to: @agent.email, subject: "Welcome to Provide Chat!")
  end
end
