class StripeMailer < ActionMailer::Base
  default from: 'you@example.com'

  def admin_dispute_created(charge)
    @charge = charge
    @sale = Sale.find_by(stripe_id: @charge.id)
    if @sale
      mail(to: 'you@example.com', subject: "Dispute created on charge #{@sale.guid} (#{charge.id})").deliver_later
    end
  end
  
  def admin_charge_succeeded(charge)
    @charge = charge
    mail(to: 'you@example.com', subject: 'Woo! Charge Succeeded!')
  end

  def receipt(charge)
    @charge = charge
    @sale = Sale.find_by!(stripe_id: @charge.id)
    mail(to: @sale.email, subject: "Thanks for purchasing #{@sale.product.name}")
  end

  def card_expiring(organization)
    @charge = charge
    @sale = Sale.find_by!(stripe_id: @charge.id)
    mail(to: @sale.email, subject: "Thanks for purchasing #{@sale.product.name}")
  end
end
