class TrialPeriodExpiry
  include Sidekiq::Worker

  def perform
    organizations = Organization.where("account_type = ? AND trial_period_start > ?", Organization.account_type[:trial], 15.days.ago)

    organizations.each do |organization|
      organization.account_type = 'free'
      organization.save
    end
  end
end