class Subscription < ActiveRecord::Base
  belongs_to :user

  has_paper_trail
end
