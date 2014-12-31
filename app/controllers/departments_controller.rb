class DepartmentsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_department, only: [:edit, :update, :destroy]
  before_action :set_websites, only: [:edit, :new]

  def index
    if params.has_key?(:websites)
      @websites = Website.where("id" => params[:websites])
      @departments = Department.includes(:websites).where(organization_id: current_agent.organization_id).where("departments_websites.website_id" => params[:websites])
    else
      @departments = Department.where(organization_id: current_agent.organization_id)
    end
    #logger.info @websites

    respond_to do |format|
      format.html
      format.json { render json: @departments }
    end
  end

  def new
    @department = Department.new
  end

  def edit
  end

  def create
    @department = Department.new(department_params)
    @department.organization_id = current_agent.organization_id

    if @department.save
      redirect_to departments_url, :flash => { :success => 'Department was successfully updated.' }
    else
      render :new
    end
  end

  def update
    if @department.update(department_params)
      redirect_to departments_url, :flash => { :success => 'Department was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    @department.destroy
    redirect_to departments_url, :flash => { :success => 'Department was successfully updated.' }
  end

  private
    def set_department
      @department = Department.find(params[:id])
    end

    def set_websites
      @websites = Website.where(organization_id: current_agent.organization_id)
    end

    def department_params
      params.require(:department).permit(:name, :email, website_ids: [])
    end
end
