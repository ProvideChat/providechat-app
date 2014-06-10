class PrechatFormsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_websites, only: [:edit, :update]

  # GET /prechat_surveys/1/edit
  def edit
    params.has_key?(:website_id) ? website_id = params[:website_id] : website_id = Website.where(organization_id: current_agent.organization_id).first
    
    if (website_id) 
      @prechat_form = PrechatForm.where(:website_id => params[:website_id]) if params.has_key?(:website_id)
    end
  end

  # PATCH/PUT /prechat_surveys/1
  # PATCH/PUT /prechat_surveys/1.json
  def update
    @prechat_form = PrechatForm.find(params[:id])
    
    respond_to do |format|
      if @prechat_form.update(prechat_form_params)
        format.html { redirect_to @prechat_form, notice: 'Prechat survey was successfully updated.' }
        format.json { render :show, status: :ok, location: @prechat_form }
      else
        format.html { render :edit }
        format.json { render json: @prechat_form.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_websites
      @websites = Website.where(organization_id: current_agent.organization_id)
    end

    def prechat_form_params
      params.require(:prechat_form).permit(:website_id, :enabled, :intro_text, :name_text, :email_text, :email_enabled, :department_text, :department_enabled, :message_text, :button_text)
    end
end
