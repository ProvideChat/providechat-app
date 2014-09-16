class AgentsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_agent, only: [:edit, :update, :destroy]

  # GET /agents
  # GET /agents.json
  def index
    @agents = Agent.where(organization_id: current_agent.organization_id)
  end

  # GET /agents/new
  def new
    @agent = Agent.new
  end

  # GET /agents/1/edit
  def edit
  end

  # POST /agents
  # POST /agents.json
  def create
    @agent = Agent.new(agent_params)
    @agent.organization_id = current_agent.organization_id

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

  # PATCH/PUT /agents/1
  # PATCH/PUT /agents/1.json
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

  # DELETE /agents/1
  # DELETE /agents/1.json
  def destroy
    @agent.destroy
    respond_to do |format|
      format.html { redirect_to agents_url, notice: 'Agent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent
      @agent = Agent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def agent_params
      params.require(:agent).permit(:name, :display_name, :email, :password, :password_confirmation, :account_type, :availability, :curr_chats, :max_chats, :active_chat_sound, :background_chat_sound, :visitor_arrived_sound, :avatar, :status)
    end
end
