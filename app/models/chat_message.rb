class ChatMessage < ActiveRecord::Base
  belongs_to :chat

  enum sender: [:visitor, :agent, :system]
end
