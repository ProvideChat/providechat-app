class AgentMailer < ApplicationMailer
  default from: 'noreply@providechat.com'

  def welcome(agent_id)
    @agent = Agent.find(agent_id)

    mail(to: @user.email, subject: "Welcome to Provide Chat!")
  end
end
