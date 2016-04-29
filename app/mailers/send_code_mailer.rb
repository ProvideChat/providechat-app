class SendCodeMailer < ApplicationMailer
  def send_code(organization_id, webmaster_email, agent_name)
    require 'htmlentities'

    subject = "Code for your website"
    @widget_code = render_to_string("home/_widget_include_code", 
                                     locals: { organization_id: organization_id }, 
                                     layout: false)
    #logger.info("WIDGET CODE: #{@widget_code}")
    @widget_code_encoded = HTMLEntities.new.encode(@widget_code, :basic)
    @agent_name = agent_name
    @organization_id = organization_id
    mail(to: webmaster_email, subject: subject)
  end
end
