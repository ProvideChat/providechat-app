class Subscription < ActiveRecord::Base
  belongs_to :organization

  validates :stripe_id, uniqueness: true
  has_paper_trail
end
