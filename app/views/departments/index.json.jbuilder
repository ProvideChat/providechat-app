json.array!(@departments) do |department|
  json.extract! department, :id, :organization_id, :name, :email, :status
  json.url department_url(department, format: :json)
end
