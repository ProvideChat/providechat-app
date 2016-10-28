class RapidResponse < ActiveRecord::Base
  belongs_to :organization
  belongs_to :website
end
