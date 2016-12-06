#
# StripeAdminMailer contains all stripe-related administrative
# emails.
#

class StripeAdminMailer < ApplicationMailer

  layout 'basic_mailer'

  default to: 'sales@providechat.com'

  def dispute_created(charge)
    @charge = charge
    @sale = Sale.find_by(stripe_id: @charge.id)
    if @sale
      mail(subject: "Dispute created on charge #{@sale.guid} (#{charge.id})").deliver_later
    end
  end
  
  def charge_succeeded(charge)
    @charge = charge
    mail(subject: 'Stripe Charge Succeeded')
  end

  def subscription_created(subscription)
    @subscription = subscription
    mail(subject: 'New Subscription Started!')
  end

  def subscription_deleted(subscription)
    @subscription = subscription
    mail(subject: 'Subscription has been cancelled')
  end
end
