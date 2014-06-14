json.array!(@chats) do |chat|
  json.extract! chat, :id, :organization_id, :website_id, :visitor_id, :agent_id, :agent_typing, :visitor_typing, :chat_requested, :chat_accepted, :chat_ended, :visitor_name, :visitor_email, :visitor_department, :visitor_question, :status
  json.url chat_url(chat, format: :json)
end
