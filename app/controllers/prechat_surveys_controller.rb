class PrechatSurveysController < ApplicationController
  before_action :set_prechat_survey, only: [:show, :edit, :update, :destroy]

  # GET /prechat_surveys
  # GET /prechat_surveys.json
  def index
    @prechat_surveys = PrechatSurvey.all
  end

  # GET /prechat_surveys/1
  # GET /prechat_surveys/1.json
  def show
  end

  # GET /prechat_surveys/new
  def new
    @prechat_survey = PrechatSurvey.new
  end

  # GET /prechat_surveys/1/edit
  def edit
  end

  # POST /prechat_surveys
  # POST /prechat_surveys.json
  def create
    @prechat_survey = PrechatSurvey.new(prechat_survey_params)

    respond_to do |format|
      if @prechat_survey.save
        format.html { redirect_to @prechat_survey, notice: 'Prechat survey was successfully created.' }
        format.json { render :show, status: :created, location: @prechat_survey }
      else
        format.html { render :new }
        format.json { render json: @prechat_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prechat_surveys/1
  # PATCH/PUT /prechat_surveys/1.json
  def update
    respond_to do |format|
      if @prechat_survey.update(prechat_survey_params)
        format.html { redirect_to @prechat_survey, notice: 'Prechat survey was successfully updated.' }
        format.json { render :show, status: :ok, location: @prechat_survey }
      else
        format.html { render :edit }
        format.json { render json: @prechat_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prechat_surveys/1
  # DELETE /prechat_surveys/1.json
  def destroy
    @prechat_survey.destroy
    respond_to do |format|
      format.html { redirect_to prechat_surveys_url, notice: 'Prechat survey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prechat_survey
      @prechat_survey = PrechatSurvey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prechat_survey_params
      params.require(:prechat_survey).permit(:organization_id, :website_id, :enabled, :intro_text, :name_text, :email_text, :email_enabled, :department_text, :department_enabled, :message_text, :button_text)
    end
end
