class ChatWidgetsController < ApplicationController
  before_action :authenticate_agent!, raise: false
  before_action :set_websites, only: [:index, :edit]

  def index
    website_id = params.key?(:website_id) ? params[:website_id] : Website.where(organization_id: current_agent.organization_id).first.id

    return unless website_id
    @chat_widget = ChatWidget.find_by(website_id: website_id)
    redirect_to edit_chat_widget_path(@chat_widget)
  end

  def edit
    @chat_widget = ChatWidget.find(params[:id])
  end

  def update
    @chat_widget = ChatWidget.find(params[:id])

    if @chat_widget.process_update(params, chat_widget_params)
      redirect_to edit_chat_widget_path(@chat_widget),
        flash: {success: "Chat widget was successfully updated."}
    else
      render :edit
    end
  end

  private

  def set_websites
    @websites = Website.where(organization_id: current_agent.organization_id)
  end

  def chat_widget_params
    params.require(:chat_widget).permit(:online_message, :offline_message,
      :title_message, :hide_when_offline,
      :color, :logo, :remove_logo,
      :logo_cache, :display_logo,
      :display_agent_avatar,
      :display_mobile_icon)
  end
end
