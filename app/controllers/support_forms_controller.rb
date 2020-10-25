class SupportFormsController < ApplicationController
  before_action :authenticate_agent!, raise: false

  def new
    @support_form = SupportForm.new
  end

  def create
    @support_form = SupportForm.new(params[:support_form])
    @support_form.request = request
    if @support_form.deliver
      flash.now[:notice] = "Thank you for your message!"
    else
      render :new
    end
  rescue ScriptError
    flash[:error] = "Sorry, this message appears to be spam and was not delivered."
  end
end
