class CreateSubscription
  def self.call(organization, quantity, email_address, token)
    subscription = Subscription.new(
      quantity: quantity,
      organization_id: organization.id
    )

    begin
      stripe_sub = nil
      if organization.stripe_customer_id.blank?
        customer = Stripe::Customer.create(
          card: token,
          email: email_address,
          plan: 'agent',
          quantity: quantity,
          active_until: Date.today + 1.month
        )
        organization.stripe_customer_id = customer.id
        organization.account_type = "paid"
        organization.save!
        stripe_sub = customer.subscriptions.first
      else
        customer = Stripe::Customer.retrieve(organization.stripe_customer_id)
        stripe_sub = customer.subscriptions.create(
          plan: plan.stripe_id
        )
      end

      subscription.stripe_id = stripe_sub.id

      subscription.save!
    rescue Stripe::StripeError => e
      subscription.errors[:base] << e.message
    end

    subscription
  end
end