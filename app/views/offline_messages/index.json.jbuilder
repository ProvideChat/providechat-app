json.array!(@offline_messages) do |offline_message|
  json.extract! offline_message, :id, :organization_id, :website_id, :intro_text, :name_text, :email_text, :email_enabled, :department_text, :department_enabled, :message_text, :button_text, :success_message
  json.url offline_message_url(offline_message, format: :json)
end
