module WebsiteHelper
  def widget_status_label(status)
    case status
    when "Not Installed"
      label :website, status, class: "label label-default"
    when "Online"
      label :website, status, class: "label label-success"
    when "Offline"
      label :website, status, class: "label label-danger"
    end
  end
end
