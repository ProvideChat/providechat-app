class InvitationsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_websites, only: [:index, :edit]

  def index
    params.has_key?(:website_id) ? website_id = params[:website_id] : website_id = Website.where(organization_id: current_agent.organization_id).first

    if website_id
      @invitation = Invitation.find_by(:website_id => website_id)
      redirect_to edit_invitation_path(@invitation.id)
    else
      redirect_to websites_path, notice: "You need to add a website before you can modify the Chat Widget"
    end
  end

  def edit
    @invitation = Invitation.find(params[:id])
  end

  def update
    @invitation = Invitation.find(params[:id])

    respond_to do |format|
      if @invitation.update(invitation_params)
        format.html { redirect_to @invitation, notice: 'Invitation was successfully updated.' }
        format.json { render :show, status: :ok, location: @invitation }
      else
        format.html { render :edit }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def set_websites
      @websites = Website.where(organization_id: current_agent.organization_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:organization_id, :website_id, :invitation_message, :smart_invite_enabled, :smart_invite_mode, :invite_pageviews, :invite_seconds)
    end
end
