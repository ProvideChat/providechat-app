class RegistrationsController < Devise::RegistrationsController
  def create
    super
    
    organization = Organization.create_default_organization

    resource.title = 'Support Hero'
    resource.access_level = 'superadmin'
    resource.organization_id = organization.id
    resource.save(validate: false)
    
    AgentMailer.welcome(resource.id).deliver_later
  end

  private
  
  def sign_up_params
    params.require(:agent).permit(:email)
  end

  def account_update_params
    params.require(:agent).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end
