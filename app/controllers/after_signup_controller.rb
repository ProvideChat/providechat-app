class AfterSignupController < ApplicationController

  before_filter :authenticate_agent!
  before_filter :validate_superadmin
  before_filter :validate_setup_incomplete

  layout 'after_signup'

  def edit
    @agent = current_agent
    @website = Website.find_or_create_by(organization_id: @agent.organization_id)
    @organization = Organization.find(@agent.organization_id)

    sign_in(@agent, :bypass => true)

    params.key?(:setup_step) ? @setup_step = params[:setup_step] : @setup_step = @organization.setup_step
  end

  def update
    @agent = current_agent
    @organization = Organization.find(@agent.organization_id)

    case @organization.setup_step
    when 1
      if process_step_one(@agent, params)
        @organization.setup_step = 2
        @organization.save
      end
    when 2
      if result = process_step_two(@agent, params)
        @organization.setup_step = 3
        @organization.save
      end
    when 3
      if result = process_step_three(@agent, params)
        @organization.completed_setup = true
        @organization.save
        sign_in(@agent, :bypass => true)
        redirect_to dashboard_path, notice: 'Your account has been successfully set up.'
      end
    end

    #if @agent.update_attributes(agent_params) && @website.save
    #  @agent.display_name = @agent.name
    #  @agent.completed_setup = true
    #  @agent.skip_confirmation!
    #  @agent.websites << @website
    #  if @agent.save
    #    sign_in(@agent, :bypass => true)
    #    redirect_to dashboard_path, notice: 'Your account has been successfully set up.'
    #  else
    #    render action: 'edit'
    #  end
    #else
    #  render action: 'edit'
    #end
    render action: 'edit'
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

  def validate_setup_incomplete
    unless current_agent.organization.completed_setup == false
      redirect_to dashboard_path
    end
  end

  def process_step_one(agent, params)
    if params[:agent].has_key?(:name)
      agent.display_name = params[:agent][:name]
    end
    if agent.update_attributes(agent_params)
      agent.display_name = @agent.name
      agent.skip_confirmation!
      agent.save
    end
  end

  def process_step_two(params)
    @website = Website.find_or_create_by(organization_id: @agent.organization_id)
    if params[:agent] && params[:agent][:website_url]
      @website.url = params[:agent][:website_url]
      @website.name = params[:agent][:website_url]
      @website.email = @agent.email
    end
    if @website.save
      @agent.websites << @website
      @agent.save
    end
  end

  def process_step_three(params)
    @agent.completed_setup = true
    @agent.save

    @agent.organization.completed_setup = true
    

    sign_in(@agent, :bypass => true)
    redirect_to dashboard_path, notice: 'Your account has been successfully set up.'
  end

end