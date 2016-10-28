class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :verify_completed_setup
  around_action :set_time_zone, if: :current_agent

  layout :layout_by_resource

  before_action do
    if current_admin
      Rack::MiniProfiler.authorize_request
    end
  end

  def layout_by_resource
    if devise_controller? && resource_name == :admin
      "admin"
    elsif devise_controller? #&& resource_name == :agent && action_name == 'new'
      "devise"
    else
      "application"
    end
  end

  def after_sign_in_path_for(resource)
    Rails.logger.info "Resource class name: #{resource.class.name}"
    if resource.class.name == 'Admin'
      rails_admin_path
    elsif resource.class.name =='Agent' 
      if resource.organization && resource.organization.completed_setup
        dashboard_path
      else
        edit_after_signup_path(resource)
      end
    end
  end

  def verify_completed_setup
    if agent_signed_in? && current_agent.organization.completed_setup == false
      redirect_to edit_after_signup_path(current_agent) unless controller_name == 'after_signup'
    end
  end

  private

  def set_time_zone(&block)
    Time.use_zone(current_agent.time_zone, &block)
  end
end
