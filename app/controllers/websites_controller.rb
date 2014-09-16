class WebsitesController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_website, only: [:edit, :update, :destroy]

  # GET /websites
  # GET /websites.json
  def index
    @websites = Website.where(organization_id: current_agent.organization_id)
  end

  # GET /websites/new
  def new
    @website = Website.new
  end

  # GET /websites/1/edit
  def edit
  end

  # POST /websites
  # POST /websites.json
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

  # PATCH/PUT /websites/1
  # PATCH/PUT /websites/1.json
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

  # DELETE /websites/1
  # DELETE /websites/1.json
  def destroy
    @website.destroy
    respond_to do |format|
      format.html { redirect_to websites_url, notice: 'Website was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_website
      @website = Website.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def website_params
      params.require(:website).permit(:organization_id, :url, :name, :default_department, :logo, :status)
    end
end
