class OfflineFormsController < ApplicationController
  before_action :authenticate_agent!

  def index
    params.has_key?(:website_id) ? website_id = params[:website_id] : website_id = Website.where(organization_id: current_agent.organization_id).first

    if website_id
      @offline_form = OfflineForm.find_by(:website_id => website_id)
      redirect_to edit_offline_form_path(@offline_form)
    else
      redirect_to websites_path, :flash => { :warning => "You need to add a website before you can modify the Chat Widget" }
    end
  end

  def edit
    @offline_form = OfflineForm.find(params[:id])
    @chat_widget = ChatWidget.find_by(:website_id => @offline_form.website_id)
    @websites = Website.where(organization_id: current_agent.organization_id)
    @departments = Website.find(@offline_form.website_id).departments
  end

  def update
    @offline_form = OfflineForm.find(params[:id])

    if flash_message = @offline_form.process_update(params, offline_form_params)
      redirect_to edit_offline_form_path(@offline_form), :flash => { :success => flash_message }
    else
      render :edit
    end
  end

  private

  def offline_form_params
    params.require(:offline_form).permit(:intro_text, :name_text, :email_text, :email_enabled, :department_text, :department_enabled, :message_text, :button_text, :success_message)
  end
end
