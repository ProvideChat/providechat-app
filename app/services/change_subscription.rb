class ChangeSubscription
  def self.call(organization, subscription, to_quantity, to_plan, email_address)
    
    from_plan = subscription.plan_id
    from_quantity = subscription.quantity
    begin
      customer = Stripe::Customer.retrieve(organization.stripe_customer_id)
      if customer.email != email_address
        customer.email = email_address
        customer.save
      end
      stripe_sub = customer.subscriptions.retrieve(subscription.stripe_id)

      stripe_sub.plan = to_plan
      stripe_sub.quantity = to_quantity
      stripe_sub.save

      subscription.quantity = to_quantity
      subscription.plan_id = to_plan      
      subscription.interval = stripe_sub.plan.interval
      subscription.amount = stripe_sub.plan.amount
      subscription.current_period_end = Time.at(stripe_sub.current_period_end)
      subscription.current_period_start = Time.at(stripe_sub.current_period_start)

      if (subscription.interval == "year")
        subscription.active_until = 1.year.from_now
      elsif (subscription.interval == "month")
        subscription.active_until = 1.month.from_now
      end
      
      subscription.save!
    rescue Stripe::StripeError => e
      subscription.errors[:base] << e.message
    end

    subscription
  end
end