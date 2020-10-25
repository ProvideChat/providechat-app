#
# StripeUserMailer contains all stripe-related emails
# that go out to actual users and thus they require
# a pretty design
#

class StripeUserMailer < ApplicationMailer
  layout "mailer"

  default from: "noreply@providechat.com"

  def receipt(charge)
    @charge = charge
    @organization = Organization.find_by!(stripe_customer_id: @charge.customer)
    @agent = Agent.find_by!(organization_id: @organization.id, access_level: Agent.access_levels[:superadmin])
    mail(to: @agent.email, subject: "Thanks for subscribing to Provide Chat!")
  end

  def card_expiring(organization)
    # @charge = charge
    # @sale = Sale.find_by!(stripe_id: @charge.id)
    # mail(to: @sale.email, subject: "Thanks for purchasing #{@sale.product.name}")
  end
end
