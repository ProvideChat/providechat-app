class RegistrationsController < Devise::RegistrationsController
  def create
    super

    return unless resource.save
    organization = Organization.create_default_organization

    resource.access_level = 'superadmin'
    resource.organization_id = organization.id
    resource.save

    # sign_in(resource_name, resource)
  end
end
