class ErrorsController < ApplicationController
  layout :layout_by_session

  def layout_by_session
    if current_agent
      "application"
    else
      "devise"
    end
  end

  def not_found
    render(status: 404)
  end

  def internal_server_error
    render(status: 500)
  end
end
