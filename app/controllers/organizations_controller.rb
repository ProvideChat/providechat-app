class OrganizationsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_organization, only: [:edit, :update]
  before_action :validate_admin

  def edit
  end

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

  def set_organization
    @organization = Organization.find(current_agent.organization_id)
  end

  def organization_params
    params.require(:organization).permit(:agent_session_timeout,
                                         :agent_response_timeout )
  end

  def validate_admin
    if current_agent.access_level == 'agent'
      redirect_to monitor_path
    end
  end
end
