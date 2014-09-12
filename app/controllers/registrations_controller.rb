class RegistrationsController < Devise::RegistrationsController
  protected
  
  def after_sign_up_path_for(resource)

    organization = Organization.new
    organization.email = resource.email
    #organization.edition = 'trial'
    organization.status = 'enabled'
    organization.save
  
    resource.account_type = 'superadmin'
    resource.organization_id = organization.id
    resource.save
  
    sign_in(resource_name, resource)
  end
end