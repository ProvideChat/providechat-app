class SettingsController < ApplicationController
  before_action :authenticate_agent!, raise: false

  respond_to :json

  def update
    @agent = Agent.find(params[:id])
    if @agent.update(agent_params)
      render json: @agent
    else
      render json: @agent.errors, status: :unprocessable_entity
    end
  end

  private

  def agent_params
    params.require(:agent).permit(
      :active_chat_sound,
      :background_chat_sound,
      :visitor_arrived_sound
    )
  end
end
