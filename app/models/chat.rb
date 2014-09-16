class Chat < ActiveRecord::Base
  belongs_to :organization
  belongs_to :agent
  belongs_to :visitor
  belongs_to :website
  belongs_to :department

  enum status: [:not_started , :in_progress, :operator_ended, :visitor_ended, :operator_timeout, :visitor_timeout]
end
