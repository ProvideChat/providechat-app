class RegistrationsController < Devise::RegistrationsController
  def create
    super

    organization = Organization.create_default_organization

    resource.name = 'Agent'
    resource.title = 'Support Hero'
    resource.access_level = 'superadmin'
    resource.organization_id = organization.id
    resource.save
  end

  private
  
  def sign_up_params
    params.require(:agent).permit(:email, :password)
  end

  def account_update_params
    params.require(:agent).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end
