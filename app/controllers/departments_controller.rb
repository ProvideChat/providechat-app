class DepartmentsController < ApplicationController
  before_action :authenticate_agent!
  before_action :set_department, only: [:edit, :update, :destroy]

  def index
    @departments = Department.where(organization_id: current_agent.organization_id)
  end

  def new
    @department = Department.new
  end

  def edit
  end

  def create
    @department = Department.new(department_params)
    @department.organization_id = current_agent.organization_id
    @department.status = 'enabled'

    respond_to do |format|
      if @department.save
        format.html { redirect_to departments_url, notice: 'Department was successfully created.' }
        format.json { render :show, status: :created, location: departments_url }
      else
        format.html { render :new }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to departments_url, notice: 'Department was successfully updated.' }
        format.json { render :show, status: :ok, location: departments_url }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url, notice: 'Department was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_department
      @department = Department.find(params[:id])
    end

    def department_params
      params.require(:department).permit(:name, :email, :status)
    end
end
