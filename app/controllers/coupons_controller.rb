class CouponsController < ApplicationController
  before_action :authenticate_agent!, raise: false

  def show
    coupon = params[:id]
    Rails.logger.info params

    response, errors = RetrieveCoupon.call(
      coupon: coupon
    )

    Rails.logger.info "ERRORS: #{errors}"

    render json: {coupon: response}
  end
end
