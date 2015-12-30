class ChangeSubscriptionCard
  def self.call(organization, subscription, token)

    begin
      customer = Stripe::Customer.retrieve(organization.stripe_customer_id)
      stripe_sub = customer.subscriptions.retrieve(subscription.stripe_id)

      stripe_sub.source = token
      stripe_sub.save
    rescue Stripe::StripeError => e
      subscription.errors[:base] << e.message
    end

    subscription
  end
end