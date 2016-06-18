class StripeMailer < ApplicationMailer

  def admin_dispute_created(charge)
    @charge = charge
    @sale = Sale.find_by(stripe_id: @charge.id)
    if @sale
      mail(to: 'derek@providechat.com', subject: "Dispute created on charge #{@sale.guid} (#{charge.id})").deliver_later
    end
  end
  
  def admin_charge_succeeded(charge)
    @charge = charge
    mail(to: 'derek@providechat.com', subject: 'Woo! Charge Succeeded!')
  end

  def receipt(charge)
    @charge = charge
    @organization = Organization.find_by!(stripe_customer_id: @charge.customer)
    @agent = Agent.find_by!(organization_id: @organization.id, access_level: Agent.access_levels[:superadmin])
    mail(to: @agent.email, subject: "Thanks for subscribing to Provide Chat!")
  end

  def card_expiring(organization)
    #@charge = charge
    #@sale = Sale.find_by!(stripe_id: @charge.id)
    #mail(to: @sale.email, subject: "Thanks for purchasing #{@sale.product.name}")
  end
end
