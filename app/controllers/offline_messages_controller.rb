class OfflineMessagesController < ApplicationController
  before_action :set_offline_message, only: [:edit, :update, :destroy]

  # GET /offline_messages
  # GET /offline_messages.json
  def index
    @offline_messages = OfflineMessage.all
  end

  # GET /offline_messages/new
  def new
    @offline_message = OfflineMessage.new
  end

  # GET /offline_messages/1/edit
  def edit
  end

  # POST /offline_messages
  # POST /offline_messages.json
  def create
    @offline_message = OfflineMessage.new(offline_message_params)

    respond_to do |format|
      if @offline_message.save
        format.html { redirect_to @offline_message, notice: 'Offline message was successfully created.' }
        format.json { render :show, status: :created, location: @offline_message }
      else
        format.html { render :new }
        format.json { render json: @offline_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offline_messages/1
  # PATCH/PUT /offline_messages/1.json
  def update
    respond_to do |format|
      if @offline_message.update(offline_message_params)
        format.html { redirect_to @offline_message, notice: 'Offline message was successfully updated.' }
        format.json { render :show, status: :ok, location: @offline_message }
      else
        format.html { render :edit }
        format.json { render json: @offline_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offline_messages/1
  # DELETE /offline_messages/1.json
  def destroy
    @offline_message.destroy
    respond_to do |format|
      format.html { redirect_to offline_messages_url, notice: 'Offline message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offline_message
      @offline_message = OfflineMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offline_message_params
      params.require(:offline_message).permit(:website_id, :intro_text, :name_text, :email_text, :email_enabled, :department_text, :department_enabled, :message_text, :button_text, :success_message)
    end
end
