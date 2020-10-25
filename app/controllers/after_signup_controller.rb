class AfterSignupController < ApplicationController
  before_action :authenticate_agent!, raise: false
  before_action :validate_superadmin
  before_action :validate_setup_incomplete

  layout "after_signup"

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
      @organization.setup_step = 2 if process_step_one(@agent, params)
    when 2
      @organization.setup_step = 3 if process_step_two(@agent, params)
    when 3
      @organization.completed_setup = true if params[:finish]
    end

    @organization.save

    if @organization.completed_setup
      AdminMailer.onboarding_completed(@agent.id).deliver_later
      redirect_to dashboard_path, notice: "Your account has been successfully set up."
    else
      @setup_step = params.key?(:previous_step) ? params[:previous_step].to_i : @organization.setup_step
      @website = Website.find_or_initialize_by(organization_id: @organization.id)
      render action: "edit"
    end
  end

  def add_ftp_server
    if params.has_key?(:agree_to_terms) && params[:agree_to_terms] == "Yes"
      organization_ftp_server = OrganizationFtpServer.find_or_initialize_by(organization_id: current_agent.organization_id)
      organization_ftp_server.host_address = params[:host_address]
      organization_ftp_server.username = params[:username]
      organization_ftp_server.password = params[:password]
      organization_ftp_server.directory = params[:directory]
      organization_ftp_server.comments = params[:comments]
      organization_ftp_server.status = "waiting_setup"
      organization_ftp_server.save

      AdminMailer.ftp_info_submitted(current_agent.id).deliver_later
      head :ok
    else
      render json: {status: :unprocessable_entity}
    end
  end

  private

  def agent_params
    params.require(:agent).permit(:name, :password, :password_confirmation, :website_url, :time_zone)
  end

  def validate_superadmin
    unless current_agent.access_level == "superadmin"
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
    end
    sign_in :agent, agent, bypass: true if agent
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
    sign_in :agent, agent, bypass: true if agent
  end
end
