class VisitorArchive < ActiveRecord::Base
  belongs_to :organization
  belongs_to :website

  enum status: [:no_chat, :waiting_to_chat, :in_chat, :chat_ended, :offsite]
end
