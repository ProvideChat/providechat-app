class ChatWidgetsController < ApplicationController
  before_action :set_chat_widget, only: [:edit, :update, :destroy]

  # GET /chat_widgets
  # GET /chat_widgets.json
  def index
    @chat_widgets = ChatWidget.all
  end

  # GET /chat_widgets/new
  def new
    @chat_widget = ChatWidget.new
  end

  # GET /chat_widgets/1/edit
  def edit
  end

  # POST /chat_widgets
  # POST /chat_widgets.json
  def create
    @chat_widget = ChatWidget.new(chat_widget_params)

    respond_to do |format|
      if @chat_widget.save
        format.html { redirect_to @chat_widget, notice: 'Chat widget was successfully created.' }
        format.json { render :show, status: :created, location: @chat_widget }
      else
        format.html { render :new }
        format.json { render json: @chat_widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chat_widgets/1
  # PATCH/PUT /chat_widgets/1.json
  def update
    respond_to do |format|
      if @chat_widget.update(chat_widget_params)
        format.html { redirect_to @chat_widget, notice: 'Chat widget was successfully updated.' }
        format.json { render :show, status: :ok, location: @chat_widget }
      else
        format.html { render :edit }
        format.json { render json: @chat_widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_widgets/1
  # DELETE /chat_widgets/1.json
  def destroy
    @chat_widget.destroy
    respond_to do |format|
      format.html { redirect_to chat_widgets_url, notice: 'Chat widget was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_widget
      @chat_widget = ChatWidget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_widget_params
      params.require(:chat_widget).permit(:website_id, :online_message, :offline_message, :colour, :display_logo, :display_agent_avatar, :display_mobile_icon)
    end
end
