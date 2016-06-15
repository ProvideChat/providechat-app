class SubscriptionsController < ApplicationController
  before_action :authenticate_agent!

  def index
  end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = CreateSubscription.call(
      current_agent.organization,
      params[:quantity],
      params[:plan],
      params[:email_address],
      params[:stripeToken],
      params[:couponCode]
    )
    if @subscription.errors.blank?
      flash[:notice] = 'Thank you for subscribing to Provide Chat.'
      redirect_to dashboard_path
    else
      render :new
    end
  end
  
  def update
    @subscription = Subscription.find(params[:id])
    
    if params[:subscription][:action] == "update-card"
      token = params[:stripeToken]
      
      @subscription = ChangeSubscriptionCard.call(
        current_agent.organization,
        @subscription,
        token
      )
      
      flash_message = "Your credit card has been updated successfully"
    elsif params[:subscription][:action] == "update-subscription"
      
      @subscription = ChangeSubscription.call(
        current_agent.organization,
        @subscription,
        params[:quantity],
        params[:plan],
        params[:email_address]
      )
      
      flash_message = "Your subscription has been updated successfully"
    end
    if @subscription.errors.blank?
      flash[:notice] = flash_message if flash_message
      redirect_to dashboard_path
    else
      render :edit
    end
  end
  
  def destroy
    
    if CancelSubscription.call(current_agent.organization)
      redirect_to dashboard_url, flash: { success: 'Your subscription has been cancelled' }
    else
      redirect_to edit_subscription_path(current_agent.organization.subscription), 
        flash: { error: 'Error in cancelling your subscription, please contact support' }
    end
  end
  
  def edit
    @subscription = Subscription.find(params[:id])
  end
end
