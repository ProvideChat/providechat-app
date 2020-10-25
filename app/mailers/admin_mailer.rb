class AdminMailer < ApplicationMailer
  layout "basic_mailer"

  default to: "sales@providechat.com"

  def onboarding_started(agent_id)
    @agent = Agent.find(agent_id)

    mail(subject: "Provide Chat Notification: Onboarding Started")
  end

  def onboarding_completed(agent_id)
    @agent = Agent.find(agent_id)
    @website = Website.find_by(organization_id: @agent.organization_id)

    mail(subject: "Provide Chat Notification: Onboarding Completed")
  end

  def ftp_info_submitted(agent_id)
    @agent = Agent.find(agent_id)
    @website = Website.find_by(organization_id: @agent.organization_id)

    mail(subject: "Provide Chat Notification: FTP Info Received")
  end
end
