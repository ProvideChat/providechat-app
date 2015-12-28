class AfterSignupController < ApplicationController

  before_filter :authenticate_agent!
  before_filter :validate_superadmin

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

    if params[:agent].has_key?(:name)
      @agent.display_name = params[:agent][:name]
    end

    if @agent.update_attributes(agent_params) && @website.save
      @agent.display_name = @agent.name
      @agent.completed_setup = true
      @agent.skip_confirmation!
      @agent.websites << @website
      if @agent.save
        sign_in(@agent, :bypass => true)
        redirect_to dashboard_path, notice: 'Your account has been successfully set up.'
      else
        render action: 'edit'
      end
    else
      render action: 'edit'
    end
  end

  private

  def agent_params
    params.require(:agent).permit(:name, :password, :password_confirmation, :website_url)
  end
  
  def validate_superadmin
    unless current_agent.access_level == 'superadmin'
      redirect_to dashboard_path
    end
  end

end