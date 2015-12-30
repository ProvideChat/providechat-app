class Subscription < ActiveRecord::Base
  belongs_to :organization

  validates :stripe_id, uniqueness: true
  has_paper_trail
    
  def term_cost
    self.quantity * (self.amount / 100)
  end
  
  def cost_description
    if self.plan_id == 'monthly-agent-19'
      "#{self.term_cost} / month"
    elsif self.plan_id == 'yearly-agent-180'
      "#{self.term_cost} / year"
    end
  end
end
