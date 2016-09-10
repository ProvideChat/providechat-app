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
      mail(to: 'derek@providechat.com', subject: "Dispute created on charge #{@sale.guid} (#{charge.id})").deliver_later
    end
  end
  
  def charge_succeeded(charge)
    @charge = charge
    mail(to: 'derek@providechat.com', subject: 'Woo! Charge Succeeded!')
  end

  def subscription_created(subscription)
    @subscription = subscription
    mail(to: 'derek@providechat.com', subject: 'Woo! New Subscription Started!')
  end

  def subscription_deleted(subscription)
    @subscription = subscription
    mail(to: 'derek@providechat.com', subject: 'Subscription has been cancelled')
  end
end
