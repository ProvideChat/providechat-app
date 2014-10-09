class ChatMessage < ActiveRecord::Base
  belongs_to :chat

  enum sender: [:visitor, :operator, :system]
  enum message_type: [:start_chat , :in_chat, :end_chat]
end
