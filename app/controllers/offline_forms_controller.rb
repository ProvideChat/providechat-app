class OfflineFormsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_websites, only: [:index, :edit]

  def index
    params.has_key?(:website_id) ? website_id = params[:website_id] : website_id = Website.where(organization_id: current_agent.organization_id).first

    if website_id
      @offline_form = OfflineForm.find_by(:website_id => website_id) if website_id
      redirect_to edit_offline_form_path(@offline_form)
    else
      redirect_to websites_path, notice: "You need to add a website before you can modify the Chat Widget"
    end
  end

  def edit
    @offline_form = OfflineForm.find(params[:id])
  end

  def update
    @offline_form = OfflineForm.find(params[:id])

    logger.debug offline_form_params

    if @offline_form.update(offline_form_params)
      redirect_to edit_offline_form_path(@offline_form), notice: 'Your offline form was successfully updated.'
    else
      render :edit
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
