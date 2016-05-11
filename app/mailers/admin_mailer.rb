class AdminMailer < ApplicationMailer
  layout 'mailer'

  default from: 'noreply@providechat.com'

  def onboarding_started(agent_id)
    @agent = Agent.find(agent_id)

    mail(to: "sales@providechat.com", subject: "Provide Chat Notification: Onboarding Started")
  end

  def onboarding_completed(agent_id)
    @agent = Agent.find(agent_id)
    @website = Website.where(organization_id: @agent.organization_id).first

    mail(to: "sales@providechat.com", subject: "Provide Chat Notification: Onboarding Completed")
  end
end
