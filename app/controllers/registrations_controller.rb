class RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: :create

  def new
    build_resource({})
    resource.skip_confirmation_notification!
    respond_with resource
    # resource.skip_confirmation_notification!
  end

  def create
    # honeypot trap
    redirect_to root_url if params[:content].present?

    super do |resource|
      if resource.errors.empty?
        organization = Organization.create_default_organization

        resource.title = "Support Hero"
        resource.access_level = "superadmin"
        resource.organization_id = organization.id
        resource.skip_registation_validations = true
        # resource.remember_me = true
        if resource.save!
          AdminMailer.onboarding_started(resource.id).deliver_later
          sign_in(resource, bypass: true)
        end
      end
    end
  end

  private

  def sign_up_params
    params.require(:agent).permit(:email)
  end

  def account_update_params
    params.require(:agent).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end
