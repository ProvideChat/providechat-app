class AgentMailer < BaseMandrillMailer
  def welcome(agent_id)
    agent = Agent.find(agent_id)
    subject = "Welcome to Provide Chat"
    merge_vars = {
      "EMAIL" => agent.email
    }
    body = mandrill_template("welcome", merge_vars)

    send_mail(agent.email, subject, body)
  end
end