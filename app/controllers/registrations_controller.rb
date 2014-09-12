class RegistrationsController < Devise::RegistrationsController
  
  def create
    super

    if resource.save
      organization = Organization.new
      organization.email = resource.email
      organization.account_type = 'trial'
      organization.status = 'enabled'
      organization.payment_system = 'stripe'
      organization.save
  
      resource.account_type = 'superadmin'
      resource.organization_id = organization.id
      resource.save
    end
    #sign_in(resource_name, resource)
  end
  
  protected
  
  #def after_sign_up_path_for(resource)
  #end
end