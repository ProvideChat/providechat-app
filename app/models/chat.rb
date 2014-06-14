class Chat < ActiveRecord::Base
  belongs_to :organization
  belongs_to :agent
  belongs_to :visitor
  belongs_to :website
  belongs_to :department
end
