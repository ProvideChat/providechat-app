class AfterSignupController < ApplicationController
  
  before_filter :authenticate_agent!
  layout 'after_signup'

  def edit
    @agent = current_agent
    @website = Website.find_or_create_by(organization_id: @agent.organization_id)
  end

  def update
    @agent = current_agent

    @website = Website.find_or_create_by(organization_id: @agent.organization_id)
    if params[:agent] && params[:agent][:website_url]
      @website.url = params[:agent][:website_url]
      @website.name = params[:agent][:website_url]
      @website.email = @agent.email
    end
                           
    if @agent.update_attributes(agent_params) && @website.save
      
      @agent.completed_setup = true
      @agent.save

      sign_in(@agent, :bypass => true)
      redirect_to dashboard_path, notice: 'Your account has been successfully set up.'
    else
      render action: 'edit'
    end
  end

  private

  def agent_params
    params.require(:agent).permit(:name, :password, :password_confirmation, :website_url)
  end

end