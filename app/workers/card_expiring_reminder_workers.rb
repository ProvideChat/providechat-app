class CardExpiringReminder
  include Sidekiq::Worker

  def perform
    expiring_organizations = Organization.where(
      "date_reminded is null and expiration_date <= ?",
      Date.today + 30.days
    )

    expiring_organizations.each do |organizations|
      StripeMailer.card_expiring(organization).deliver_later
      organization.update_attributes(date_reminded: Date.today)
    end
  end
end
