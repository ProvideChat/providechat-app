class OfflineFormsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_websites, only: [:index, :edit]

  def index
    params.has_key?(:website_id) ? website_id = params[:website_id] : website_id = Website.where(organization_id: current_agent.organization_id).first
    
    @offline_form = OfflineForm.find_by(:website_id => website_id) if website_id
    
    redirect_to edit_offline_form_path(@offline_form)
  end

  # GET /offline_forms/1/edit
  def edit
    
    @offline_form = OfflineForm.find(params[:id])

  end


  # PATCH/PUT /offline_forms/1
  # PATCH/PUT /offline_forms/1.json
  def update
    @offline_form = OfflineForm.find(params[:id])
    
    respond_to do |format|
      if @offline_form.update(offline_form_params)
        format.html { redirect_to @offline_message, notice: 'Offline form was successfully updated.' }
        format.json { render :show, status: :ok, location: @offline_form }
      else
        format.html { render :edit }
        format.json { render json: @offline_form.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_websites
      @websites = Website.where(organization_id: current_agent.organization_id)
    end

    def offline_form_params
      params.require(:offline_form).permit(:intro_text, :name_text, :email_text, :email_enabled, :department_text, :department_enabled, :message_text, :button_text, :success_message)
    end
end
