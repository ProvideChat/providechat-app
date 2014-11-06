class OrganizationsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_organization, only: [:edit, :update]

  # GET /organizations/1/edit
  def edit
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to edit_organization_path(@organization), notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: edit_organization_path(@organization) }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(current_agent.organization_id)
    end

    def organization_params
      params.require(:organization).permit(:email, :default_department,
          :agent_session_timeout, :agent_response_timeout )
    end
end
