module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  BOOTSTRAP_FLASH_MSG = {
    success: "success",
    error: "danger",
    alert: "warning",
    notice: "info"
  }

  def flash_class(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, "")
  end
end
