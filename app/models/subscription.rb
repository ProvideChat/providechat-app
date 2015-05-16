class Subscription < ActiveRecord::Base
  belongs_to :organization

  validates :stripe_id, uniqueness: true
  has_paper_trail
  
  AGENT_COST = 15
  
  def monthly_cost
    self.quantity * AGENT_COST
  end
end
