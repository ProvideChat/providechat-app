class AfterSignupController < ApplicationController
  before_filter :authenticate_agent!
  
  def edit
    @agent = current_agent
  end
  
  def update
  end
  
  private
  
  def agent_params
  end
end