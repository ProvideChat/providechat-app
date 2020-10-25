class RetrieveCoupon
  def self.call(coupon:)
    begin
      response = Stripe::Coupon.retrieve(coupon)
    rescue Stripe::StripeError => e
      Rails.logger.info "ERROR Object: #{e.inspect}"
      errors = e.message
    end

    [response, errors]
  end
end
