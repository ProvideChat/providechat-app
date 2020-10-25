class PrechatFormsController < ApplicationController
  before_action :authenticate_agent!, raise: false
  before_action :validate_admin

  def index
    website_id = params.key?(:website_id) ? params[:website_id] : Website.where(organization_id: current_agent.organization_id).first.id

    return unless website_id
    @prechat_form = PrechatForm.find_by(website_id: website_id)
    redirect_to edit_prechat_form_path(@prechat_form)
  end

  def edit
    @prechat_form = PrechatForm.find(params[:id])
    @chat_widget = ChatWidget.find_by(website_id: @prechat_form.website_id)
    @websites = Website.where(organization_id: current_agent.organization_id)
    @departments = Website.find(@prechat_form.website_id).departments
  end

  def update
    @prechat_form = PrechatForm.find(params[:id])

    if @prechat_form.process_update(params, prechat_form_params)
      redirect_to edit_prechat_form_path(@prechat_form),
        flash: {success: "Prechat survey was successfully updated."}
    else
      render :edit
    end
  end

  private

  def prechat_form_params
    params.require(:prechat_form).permit(:intro_text, :name_text, :email_text,
      :email_enabled, :department_text,
      :department_enabled, :message_text,
      :button_text)
  end

  def validate_admin
    if current_agent.access_level == "agent"
      redirect_to monitor_path
    end
  end
end
