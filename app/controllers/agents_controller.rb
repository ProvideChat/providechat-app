class AgentsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_agent, only: [:edit, :update, :destroy]

  def index
    @agents = Agent.where(organization_id: current_agent.organization_id)
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

    respond_to do |format|
      if @agent.save
        format.html { redirect_to agents_url, notice: 'Agent was successfully created.' }
        format.json { render :show, status: :created, location: agents_url }
      else
        format.html { render :new }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    if params[:agent][:password].blank? && params[:agent][:password_confirmation].blank?
        params[:agent].delete(:password)
        params[:agent].delete(:password_confirmation)
    end

    respond_to do |format|
      if @agent.update(agent_params)
        format.html { redirect_to agents_url, notice: 'Agent was successfully updated.' }
        format.json { head :ok}
      else
        format.html { render :edit }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @agent.destroy
    respond_to do |format|
      format.html { redirect_to agents_url, notice: 'Agent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_agent
      @agent = Agent.find(params[:id])
    end

    def agent_params
      params.require(:agent).permit(:name, :display_name, :email, :password, :password_confirmation, :account_type, :availability, :curr_chats, :max_chats, :active_chat_sound, :background_chat_sound, :visitor_arrived_sound, :avatar, :remove_avatar, :avatar_cache)
    end
end
