class OfflineMessagesController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_websites, only: [:edit, :update]

  # GET /offline_messages/1/edit
  def edit
    params.has_key?(:website_id) ? website_id = params[:website_id] : website_id = Website.where(organization_id: current_agent.organization_id).first
    
    if (website_id) 
      @offline_message = OfflineMessage.where(:website_id => params[:website_id]) if params.has_key?(:website_id)
    end
  end


  # PATCH/PUT /offline_messages/1
  # PATCH/PUT /offline_messages/1.json
  def update
    @offline_message = OfflineMessage.find(params[:id])
    
    respond_to do |format|
      if @offline_message.update(offline_message_params)
        format.html { redirect_to @offline_message, notice: 'Offline message was successfully updated.' }
        format.json { render :show, status: :ok, location: @offline_message }
      else
        format.html { render :edit }
        format.json { render json: @offline_message.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_websites
      @websites = Website.where(organization_id: current_agent.organization_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offline_message_params
      params.require(:offline_message).permit(:website_id, :intro_text, :name_text, :email_text, :email_enabled, :department_text, :department_enabled, :message_text, :button_text, :success_message)
    end
end
