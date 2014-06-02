json.array!(@websites) do |website|
  json.extract! website, :id, :organization_id, :url, :name, :default_department, :logo, :status
  json.url website_url(website, format: :json)
end
