json.array!(@prechat_surveys) do |prechat_survey|
  json.extract! prechat_survey, :id, :organization_id, :website_id, :enabled, :intro_text, :name_text, :email_text, :email_enabled, :department_text, :department_enabled, :message_text, :button_text
  json.url prechat_survey_url(prechat_survey, format: :json)
end
