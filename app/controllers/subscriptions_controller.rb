class SubscriptionsController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
  end

  def new
    @subscription = Subscription.new
  end

  def create
    # Get the credit card details submitted by the form
    token = params[:stripeToken]
    
    @subscription = CreateSubscription.call(
      current_agent.organization,
      params[:quantity],
      params[:email_address],
      params[:stripeToken]
    )
    if @subscription.errors.blank?
      flash[:notice] = 'Thank you for your purchase!' +
        'Please click the link in the email we just sent ' +
        'you to get started.'
      redirect_to '/'
    else
      render :new
    end
  end
  
  def edit
    @subscription = Subscription.find(params[:id])
  end
end