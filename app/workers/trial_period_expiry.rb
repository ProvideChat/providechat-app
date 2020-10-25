class TrialPeriodExpiry
  include Sidekiq::Worker

  def perform
    organizations = Organization.where("account_type = ? AND trial_period_end < ?", Organization.account_types[:trial], Date.today)

    organizations.each do |organization|
      organization.account_type = "free"
      organization.save
    end
  end
end
