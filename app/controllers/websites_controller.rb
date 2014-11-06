class WebsitesController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_website, only: [:edit, :update, :destroy]

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

    respond_to do |format|
      if @website.save
        format.html { redirect_to websites_path, notice: 'Website was successfully created.' }
        format.json { render :show, status: :created, location: websites_path }
      else
        format.html { render :new }
        format.json { render json: @website.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @website.update(website_params)
        format.html { redirect_to websites_path, notice: 'Website was successfully updated.' }
        format.json { render :show, status: :ok, location: websites_path }
      else
        format.html { render :edit }
        format.json { render json: @website.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @website.destroy
    respond_to do |format|
      format.html { redirect_to websites_url, notice: 'Website was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_website
      @website = Website.find(params[:id])
    end

    def website_params
      params.require(:website).permit(:organization_id, :url, :name, :email, :logo, :remove_logo, :logo_cache)
    end
end
