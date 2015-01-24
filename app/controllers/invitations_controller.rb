class InvitationsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_websites, only: [:index, :edit]

  def index
    params.has_key?(:website_id) ? website_id = params[:website_id] : website_id = Website.where(organization_id: current_agent.organization_id).first

    if website_id
      @invitation = Invitation.find_by(:website_id => website_id)
      redirect_to edit_invitation_path(@invitation.id)
    end
  end

  def edit
    @invitation = Invitation.find(params[:id])
    @chat_widget = ChatWidget.find_by(:website_id => @invitation.website_id)
  end

  def update
    @invitation = Invitation.find(params[:id])

    if @invitation.update(invitation_params)
      redirect_to edit_invitation_path(@invitation), :flash => { :success => 'Invitation was successfully updated.' }
    else
      render :edit
    end
  end

  private
  
  def set_websites
    @websites = Website.where(organization_id: current_agent.organization_id)
  end

  def invitation_params
    params.require(:invitation).permit(:organization_id, :website_id, :invitation_message, :name_text, :button_text, :invite_mode, :invite_pageviews, :invite_seconds)
  end
end
