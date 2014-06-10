class ChatWidgetsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_websites, only: [:edit, :update]

  def edit
    params.has_key?(:website_id) ? website_id = params[:website_id] : website_id = Website.where(organization_id: current_agent.organization_id).first
    
    if (website_id) 
      @chat_widget = ChatWidget.where(:website_id => params[:website_id]) if params.has_key?(:website_id)
    end
  end

  def update    
    @chat_widget = ChatWidget.find(params[:id])
    
    respond_to do |format|
      if @chat_widget.update(chat_widget_params)
        format.html { redirect_to @chat_widget, notice: 'Chat widget was successfully updated.' }
        format.json { render :show, status: :ok, location: @chat_widget }
      else
        format.html { render :edit }
        format.json { render json: @chat_widget.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_websites
      @websites = Website.where(organization_id: current_agent.organization_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_widget_params
      params.require(:chat_widget).permit(:website_id, :online_message, :offline_message, :colour, :display_logo, :display_agent_avatar, :display_mobile_icon)
    end
end
