class DepartmentsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_department, only: [:edit, :update, :destroy, :show]
  before_action :set_websites, only: [:edit, :new, :create]

  def index
    if params.key?(:websites)
      @departments = Department.where(organization_id: current_agent.organization_id, 
                                      website_id: params[:websites]).order("name ASC")
    else
      @departments = Department.where(organization_id: current_agent.organization_id)
                               .order("name ASC")
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
      redirect_to departments_url,
                  flash: { success: 'Department was successfully updated.' }
    else
      render :new
    end
  end

  def show
  end

  def update
    if @department.update(department_params)
      redirect_to departments_url,
                  flash: { success: 'Department was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    @department.destroy
    redirect_to departments_url,
                flash: { success: 'Department was successfully updated.' }
  end

  private

  def set_department
    @department = Department.find(params[:id])
  end

  def set_websites
    @websites = Website.where(organization_id: current_agent.organization_id)
  end

  def department_params
    params.require(:department).permit(:name, :email, :website_id)
  end
end
