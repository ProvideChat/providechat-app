class Subscription < ActiveRecord::Base
  belongs_to :organization

  validates :stripe_id, uniqueness: true
  has_paper_trail

  def term_cost
    quantity * (amount / 100)
  end

  def cost_description
    if plan_id == "monthly-agent-19"
      "#{term_cost} / month"
    elsif plan_id == "yearly-agent-180"
      "#{term_cost} / year"
    end
  end

  def next_payment
    Time.at(current_period_end).strftime("%B %e, %Y")
  end
end
