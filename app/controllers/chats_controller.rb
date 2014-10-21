class ChatsController < ApplicationController
  before_action :set_chat, only: [:show]


  def index
    @chats = Chat.where(organization_id: current_agent.organization_id)
    @agents = Agent.where(organization_id: current_agent.organization_id)
    @websites = Website.where(organization_id: current_agent.organization_id)
  end

  def show
    @chat = Chat.find(params[:id])
  end

end
