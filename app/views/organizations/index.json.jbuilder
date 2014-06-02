json.array!(@organizations) do |organization|
  json.extract! organization, :id, :name, :email, :widget_installed, :default_department, :edition, :payment_system
  json.url organization_url(organization, format: :json)
end
