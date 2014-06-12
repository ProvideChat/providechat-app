module ApplicationHelper

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def flash_class(level)
    case level
    when 'notice' then "info"
    when 'success' then "success"
    when 'error' then "danger"
    when 'alert' then "warning"
    end
  end

end
