class OfflineFormsController < ApplicationController
  before_action :authenticate_agent!, raise: false

  def index
    params.key?(:website_id) ? website_id = params[:website_id] : website_id = Website.where(organization_id: current_agent.organization_id).first

    return unless website_id
    @offline_form = OfflineForm.find_by(website_id: website_id)
    redirect_to edit_offline_form_path(@offline_form)
  end

  def edit
    @offline_form = OfflineForm.find(params[:id])
    @chat_widget = ChatWidget.find_by(website_id: @offline_form.website_id)
    @websites = Website.where(organization_id: current_agent.organization_id)
    @departments = Website.find(@offline_form.website_id).departments
  end

  def update
    @offline_form = OfflineForm.find(params[:id])

    if @offline_form.process_update(params, offline_form_params)
      redirect_to edit_offline_form_path(@offline_form),
                  flash: { success: 'Offline form was successfully updated.' }
    else
      render :edit
    end
  end

  private

  def offline_form_params
    params.require(:offline_form).permit(:intro_text, :name_text, :email_text,
                                         :email_enabled, :department_text,
                                         :department_enabled, :message_text,
                                         :button_text, :success_message)
  end
end
