class OrganizationFtpServer < ActiveRecord::Base
  belongs_to :organization

  enum status: [:waiting_setup, :completed_setup]
end
