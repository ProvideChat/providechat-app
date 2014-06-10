class RapidResponsesController < ApplicationController
  before_action :set_rapid_response, only: [:edit, :update, :destroy]

  # GET /rapid_responses
  # GET /rapid_responses.json
  def index
    @rapid_responses = RapidResponse.all
  end

  # GET /rapid_responses/new
  def new
    @rapid_response = RapidResponse.new
  end

  # GET /rapid_responses/1/edit
  def edit
  end

  # POST /rapid_responses
  # POST /rapid_responses.json
  def create
    @rapid_response = RapidResponse.new(rapid_response_params)

    respond_to do |format|
      if @rapid_response.save
        format.html { redirect_to @rapid_response, notice: 'Rapid response was successfully created.' }
        format.json { render :show, status: :created, location: @rapid_response }
      else
        format.html { render :new }
        format.json { render json: @rapid_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rapid_responses/1
  # PATCH/PUT /rapid_responses/1.json
  def update
    respond_to do |format|
      if @rapid_response.update(rapid_response_params)
        format.html { redirect_to @rapid_response, notice: 'Rapid response was successfully updated.' }
        format.json { render :show, status: :ok, location: @rapid_response }
      else
        format.html { render :edit }
        format.json { render json: @rapid_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rapid_responses/1
  # DELETE /rapid_responses/1.json
  def destroy
    @rapid_response.destroy
    respond_to do |format|
      format.html { redirect_to rapid_responses_url, notice: 'Rapid response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rapid_response
      @rapid_response = RapidResponse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rapid_response_params
      params.require(:rapid_response).permit(:organization_id, :name, :text, :order, :ancestry, :status)
    end
end
