class VisitorsController < ApplicationController
    
  # GET /visitors
  # GET /visitor.json
  def index
    @visitors = Visitor.where(organization_id: current_agent.organization_id)
  end

  # GET /visitors/1
  # GET /visitors/1.json
  def show
  end

  # GET /visitors/new
  def new
    @visitor = Visitor.new
  end

  # GET /visitors/1/edit
  def edit
  end

  # POST /visitors
  # POST /visitors.json
  def create
    @visitor = Visitor.new(visitor_params)

    respond_to do |format|
      if @visitor.save
        format.html { redirect_to @visitor, notice: 'Visitor was successfully created.' }
        format.json { render :show, status: :created, location: @visitor }
      else
        format.html { render :new }
        format.json { render json: @visitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visitors/1
  # PATCH/PUT /visitors/1.json
  def update
    respond_to do |format|
      if @visitor.update(visitor_params)
        format.html { redirect_to @visitor, notice: 'Visitor was successfully updated.' }
        format.json { render :show, status: :ok, location: @visitor }
      else
        format.html { render :edit }
        format.json { render json: @visitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visitors/1
  # DELETE /visitors/1.json
  def destroy
    @visitor.destroy
    respond_to do |format|
      format.html { redirect_to visitors_url, notice: 'Visitor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @visitor = Visitor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visitor_params
      params.require(:visitor).permit(:visitor_id, :agent_id, :agent_typing, :visitor_typing, :chat_requested, :chat_accepted, :chat_ended, :visitor_name, :visitor_email, :visitor_department, :visitor_question, :status)
    end
end
