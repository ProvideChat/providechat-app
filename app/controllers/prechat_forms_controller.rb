class PrechatFormsController < ApplicationController
  before_action :authenticate_agent!

  def index
    params.has_key?(:website_id) ? website_id = params[:website_id] : website_id = Website.where(organization_id: current_agent.organization_id).first

    if website_id
      @prechat_form = PrechatForm.find_by(:website_id => website_id)
      redirect_to edit_prechat_form_path(@prechat_form)
    else
      redirect_to websites_path, :flash => { :warning => "You need to add a website before you can modify the Pre-chat Form" }
    end
  end

  def edit
    @prechat_form = PrechatForm.find(params[:id])
    @websites = Website.where(organization_id: current_agent.organization_id)
    @departments = Website.find(@prechat_form.website_id).departments
  end

  def update
    @prechat_form = PrechatForm.find(params[:id])

    if flash_message = @prechat_form.process_update(params, prechat_form_params)
      redirect_to edit_prechat_form_path(@prechat_form), :flash => { :success => 'Prechat survey was successfully updated.' }
    else
      render :edit
    end
  end

  private

  def prechat_form_params
    params.require(:prechat_form).permit(:intro_text, :name_text, :email_text, :email_enabled, :department_text, :department_enabled, :message_text, :button_text)
  end
end
