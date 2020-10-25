class CancelSubscription
  def self.call(organization)
    subscription = Subscription.where(organization_id: organization.id).first

    begin
      if subscription
        customer = Stripe::Customer.retrieve(organization.stripe_customer_id)
        customer.subscriptions.retrieve(subscription.stripe_id).delete

        organization.account_type = "free"
        organization.save!

        subscription.destroy
      end
    rescue Stripe::StripeError => e
      false
    end
  end
end
