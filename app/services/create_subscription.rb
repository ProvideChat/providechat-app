class CreateSubscription
  def self.call(organization, quantity, plan, email_address, token, coupon_code)
    subscription = Subscription.new(
      quantity: quantity,
      plan_id: plan,
      organization_id: organization.id
    )

    begin
      stripe_sub = nil
      if organization.stripe_customer_id.blank?
        customer_params = {
          card: token,
          email: email_address,
          plan: plan,
          quantity: quantity
        }
        unless coupon_code.blank?
          customer_params[:coupon] = coupon_code
        end
        customer = Stripe::Customer.create(
          customer_params
        )
        Rails.logger.debug customer.to_s
        organization.stripe_customer_id = customer.id
        organization.account_type = "paid"
        organization.save!
        stripe_sub = customer.subscriptions.first
      else
        customer = Stripe::Customer.retrieve(organization.stripe_customer_id)
        stripe_sub = if coupon_code.blank?
          customer.subscriptions.create(
            plan: plan
          )
        else
          customer.subscriptions.create(
            plan: plan,
            coupon: coupon_code
          )
        end
        organization.account_type = "paid"
        organization.save!
      end

      subscription.interval = stripe_sub.plan.interval
      subscription.amount = stripe_sub.plan.amount
      subscription.current_period_end = Time.at(stripe_sub.current_period_end)
      subscription.current_period_start = Time.at(stripe_sub.current_period_start)
      subscription.stripe_id = stripe_sub.id

      if subscription.interval == "year"
        subscription.active_until = 1.year.from_now
      elsif subscription.interval == "month"
        subscription.active_until = 1.month.from_now
      end

      subscription.save!
    rescue Stripe::StripeError => e
      Rails.logger.info "STRIPE ERROR: #{e.message}"
      subscription.errors[:base] << e.message
    end

    subscription
  end
end
