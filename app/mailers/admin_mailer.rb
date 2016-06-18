class AdminMailer < ApplicationMailer
  layout 'mailer'

  default from: 'noreply@providechat.com'
  default to: 'sales@providechat.com'

  def onboarding_started(agent_id)
    @agent = Agent.find(agent_id)

    mail(subject: "Provide Chat Notification: Onboarding Started")
  end

  def onboarding_completed(agent_id)
    @agent = Agent.find(agent_id)
    @website = Website.find_by(organization_id: @agent.organization_id)

    mail(subject: "Provide Chat Notification: Onboarding Completed")
  end
end
