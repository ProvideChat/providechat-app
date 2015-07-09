class ChatsController < ApplicationController
  before_action :authenticate_agent!
  def index
    @agents = Agent.where(organization_id: current_agent.organization_id)
    @websites = Website.where(organization_id: current_agent.organization_id)

    @chats = Chat.filter_results(current_agent.organization_id, filtering_params(params))

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def show
    @chat = Chat.find(params[:id])
  end

  private

  def filtering_params(params)
    params.slice(:chat_id, :visitor_email, :website_ids, :agent_ids,
                 :from_date, :to_date)
  end
end
