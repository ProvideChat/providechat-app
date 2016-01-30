class AgentsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_agent, only: [:edit, :update, :destroy]
  before_action :setup, only: [:edit, :new, :update, :create]
  before_action :validate_admin

  def index
    @agents = Agent.for_organization(current_agent.organization_id)
  end

  def new
    @agent = Agent.new
  end

  def edit
  end

  def create
    @agent = Agent.new(agent_params)
    @agent.organization_id = current_agent.organization_id
    @agent.status = 'enabled'
    @agent.completed_setup = true
    @agent.skip_confirmation!

    if @agent.save
      redirect_to agents_url,
                  flash: { success: 'Agent was successfully created.' }
    else
      render :new
    end
  end

  def update
    if params[:agent][:password].blank? && params[:agent][:password_confirmation].blank?
      params[:agent].delete(:password)
      params[:agent].delete(:password_confirmation)
    end
    @agent.websites.delete_all
    @agent.departments.delete_all

    if @agent.update(agent_params)
      if current_agent.access_level == 'agent'
        redirect_to edit_agent_path(@agent)
      else
        redirect_to agents_url, flash: { success: 'Agent was successfully updated.' }
      end
    else
      render :edit
    end
  end

  def destroy
    @agent.destroy
    redirect_to agents_url,
                flash: { success: 'Agent was successfully deleted.' }
  end

  private

  def set_agent
    @agent = Agent.find(params[:id])
  end

  def setup
    @websites = Website.where(organization_id: current_agent.organization_id)
    @departments = Department.where(organization_id: current_agent.organization_id)
  end

  def process_department_ids(department_ids)
    if department_ids.include?(",")
      department_array = department_ids.split(",")
      department_array.delete_if{|department| department.include?(" ") }
    else
      ["#{department_ids}"]
    end
  end

  def agent_params

    params[:agent][:website_ids].delete("") if params[:agent][:website_ids]
    params[:agent][:department_ids].delete("") if params[:agent][:department_ids]

    # Remove any department IDs that belong to websites that the agent no longer
    # is assigned to
    if params[:agent][:department_ids]
      department_ids = params[:agent][:department_ids].dup
      agent_website_ids = params[:agent][:website_ids].dup
      department_ids.each do |department_id|
        department = Department.find(department_id.to_i)
        params[:agent][:department_ids].delete(department_id.to_s) unless agent_website_ids.include?(department.website_id.to_s) 
      end
    end
    
    #params[:agent][:department_ids] = process_department_ids(params[:agent][:department_ids]) if params[:agent][:department_ids]
    #logger.info "Department IDs (after): #{params[:agent][:department_ids]}";

    params.require(:agent).permit(:name, :display_name, :email, :title,
                                  :password, :password_confirmation,
                                  :access_level, :availability,
                                  :active_chat_sound, :background_chat_sound,
                                  :visitor_arrived_sound, :avatar,
                                  :remove_avatar, :avatar_cache,
                                  website_ids: [], department_ids: [])
  end

  def validate_admin
    if current_agent.access_level == 'agent' && @agent.id != current_agent.id
      redirect_to monitor_path
    end
  end
end
