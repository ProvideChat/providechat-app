class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  before_action do
    if current_admin
      Rack::MiniProfiler.authorize_request
    end
  end

  def layout_by_resource
    if devise_controller? #&& resource_name == :agent && action_name == 'new'
      "devise"
    else
      "application"
    end
  end

  # def after_sign_in_path_for(resource)
  #   if resource.completed_signup?
  #     after_signup_path
  #   else
  #     dashboard_path
  #   end
  # end

  def current_agent
    super.decorate unless super.nil?
  end
end
