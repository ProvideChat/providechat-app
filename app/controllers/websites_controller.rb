class WebsitesController < ApplicationController
  before_action :authenticate_agent!, raise: false
  before_action :set_website, only: [:edit, :update, :destroy]
  before_action :validate_admin

  def index
    @websites = Website.where(organization_id: current_agent.organization_id)
  end

  def new
    @website = Website.new
  end

  def edit
  end

  def create
    @website = Website.new(website_params)
    @website.organization_id = current_agent.organization_id

    if @website.save
      @website.assign_to_agents

      redirect_to websites_path,
        flash: {success: "Website was successfully created."}
    else
      render :new
    end
  end

  def update
    if @website.update(website_params)
      redirect_to websites_path,
        flash: {success: "Website was successfully updated."}
    else
      render :edit
    end
  end

  def destroy
    @website.destroy
    redirect_to websites_url,
      flash: {success: "Website was successfully deleted."}
  end

  private

  def set_website
    @website = Website.find(params[:id])
  end

  def website_params
    params.require(:website).permit(:organization_id, :url, :name, :email)
  end

  def validate_admin
    if current_agent.access_level == "agent"
      redirect_to monitor_path
    end
  end
end
