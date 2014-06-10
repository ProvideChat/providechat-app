json.array!(@rapid_responses) do |rapid_response|
  json.extract! rapid_response, :id, :organization_id, :name, :text, :order, :ancestry, :status
  json.url rapid_response_url(rapid_response, format: :json)
end
