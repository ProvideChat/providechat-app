class ContactFormsController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false, only: :create
  layout "devise"

  def new
    @contact_form = ContactForm.new
    resource_name = Agent.new
  end

  def create
    @contact_form = ContactForm.new(params[:contact_form])
    @contact_form.request = request
    if @contact_form.deliver
      flash.now[:notice] = "Thank you for your message!"
    else
      render :new
    end
  rescue ScriptError
    flash[:error] = "Sorry, this message appears to be spam and was not delivered."
  end
end
