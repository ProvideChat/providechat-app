class ApplicationMailer < ActionMailer::Base
  default from: "noreply@providechat.com"
  layout "mailer"
  append_view_path Rails.root.join("app", "views", "mailers")

  add_template_helper EmailHelper
end
