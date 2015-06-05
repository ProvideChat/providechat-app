class SessionsController < Devise::SessionsController
  before_filter :before_login, :only => :create
  after_filter :after_login, :only => :create

  def before_login
  end

  def after_login
    if current_agent.organization.account_type == "trial" &&
        current_agent.organization.trial_period_end < Date.today
      current_agent.organization.account_type = 'free'
      current_agent.organization.save
    end
  end
end