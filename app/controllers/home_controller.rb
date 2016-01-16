class HomeController < ApplicationController
  before_action :authenticate_agent!
  before_action :validate_admin, except: [:monitor, :signout]

  def monitor
  end

  def signout
    current_agent.availability = Agent.availabilities[:offline]
    current_agent.save
    sign_out_and_redirect(current_agent)
  end

  def dashboard
    @websites = Website.where(organization_id: current_agent.organization_id)
    @agents = Agent.where(organization_id: current_agent.organization_id)

    @blog_feed = Feedjira::Feed.fetch_and_parse('http://www.providechat.com/blog/feed')
  end

  def code
    @websites = Website.where(organization_id: current_agent.organization_id)
  end

  def send_code
    if (params.key?(:webmaster_email) && valid_email?(params[:webmaster_email]))
      webmaster_email = params[:webmaster_email]
      SendCodeMailer.send_code(current_agent.organization_id, webmaster_email, current_agent.name).deliver_later
      head :ok
    else
      render status: :unprocessable_entity
    end
  end

  def contact
  end

  private

  def valid_email?(email)
    email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  end

  def validate_admin
    if current_agent.access_level == 'agent'
      redirect_to monitor_path
    end
  end
end
