class HomeController < ApplicationController
  before_action :authenticate_agent!

  def monitor
  end

  def dashboard
    @websites = Website.where(organization_id: current_agent.organization_id)
    @agents = Agent.where(organization_id: current_agent.organization_id)

    @blog_feed = Feedjira::Feed.fetch_and_parse('http://www.providechat.com/blog/feed')
  end

  def code
    @websites = Website.where(organization_id: current_agent.organization_id)
  end

  def contact
  end
end
