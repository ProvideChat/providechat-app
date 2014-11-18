class RegistrationsController < Devise::RegistrationsController

  def create
    super

    if resource.save
      organization = Organization.create_default_organization

      resource.access_level = 'superadmin'
      resource.organization_id = organization.id
      resource.save
    end
    #sign_in(resource_name, resource)
  end

  protected

  #def after_sign_up_path_for(resource)
  #end
end