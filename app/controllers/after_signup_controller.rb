class AfterSignupController < ApplicationController

  before_filter :authenticate_agent!
  before_filter :validate_superadmin
  before_filter :validate_setup_incomplete

  layout 'after_signup'

  def edit
    @agent = current_agent
    @website = Website.find_or_create_by(organization_id: @agent.organization_id)
    @organization = Organization.find(@agent.organization_id)

    @setup_step = @organization.setup_step
  end

  def update
    @agent = current_agent
    @organization = Organization.find(@agent.organization_id)

    case params[:agent][:setup_step].to_i
    when 1
      if process_step_one(@agent, params)
        @organization.setup_step = 2
      end
    when 2
      if process_step_two(@agent, params)
        @organization.setup_step = 3
      end
    when 3
      if params[:finish] && process_step_three(@agent, params)
        @organization.completed_setup = true
      end
    end

    @organization.save

    if @organization.completed_setup
      AdminMailer.onboarding_completed(@agent.id).deliver_later
      redirect_to dashboard_path, notice: 'Your account has been successfully set up.'
    else
      params.key?(:previous_step) ? @setup_step = params[:previous_step].to_i : @setup_step = @organization.setup_step
      @website = Website.find_or_initialize_by(organization_id: @organization.id)
      render action: 'edit'
    end
  end

  def add_ftp_server
    logger.info params

    if params.has_key?(:agree_to_terms) && params[:agree_to_terms] == "Yes"
      organization_ftp_server = OrganizationFtpServer.find_or_initialize_by(organization_id: current_agent.organization_id)
      organization_ftp_server.host_address = params[:host_address]
      organization_ftp_server.username = params[:username]
      organization_ftp_server.password = params[:password]
      organization_ftp_server.directory = params[:directory]
      organization_ftp_server.comments = params[:comments]
      organization_ftp_server.status = 'waiting_setup'
      organization_ftp_server.save

      head :ok 
    else
      render json: { status: :unprocessable_entity }
    end
  end

  private

  def agent_params
    params.require(:agent).permit(:name, :password, :password_confirmation, :website_url, :time_zone)
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
      agent.save
      sign_in :agent, agent, :bypass => true
    end
  end

  def process_step_two(agent, params)
    website = Website.find_or_initialize_by(organization_id: agent.organization_id)
    if params[:agent] && params[:agent][:website_url]
      website.url = params[:agent][:website_url]
      website.name = params[:agent][:website_url]
      website.email = agent.email
    end
    if website.save
      agent.websites << website
      agent.save
    end
  end

  def process_step_three(agent, params)
    if params[:agree_to_terms]
      organization_ftp_server = OrganizationFtpServer.find_or_initialize_by(organization_id: agent.organization_id)
      organization_ftp_server.host_address = params[:host_address]
      organization_ftp_server.username = params[:username]
      organization_ftp_server.password = params[:password]
      organization_ftp_server.directory = params[:directory]
      organization_ftp_server.comments = params[:comments]
      organization_ftp_server.status = 'waiting_setup'
      organization_ftp_server.save
    end
    agent.completed_setup = true
    agent.save
  end

end
