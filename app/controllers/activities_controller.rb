class ActivitiesController < ApplicationController
  before_action :authenticate_agent!, raise: false

  def index
  
    @current_visitors = Visitor.current_visitors(current_agent)
    @offsite = Visitor.recent_offsite_visitors(current_agent)

    @visitors = @current_visitors.where("status = ?", Visitor.statuses[:no_chat])
    @waiting = @current_visitors.where("status = ?", Visitor.statuses[:waiting_to_chat])
    #@chats = @current_visitors.where("status = ?", Visitor.statuses[:in_chat])
    @chats = Chat.current_chats(current_agent.organization_id, current_agent.id, params.has_key?(:my_chats))
  end
end
