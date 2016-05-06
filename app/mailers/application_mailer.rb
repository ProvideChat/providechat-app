class ApplicationMailer < ActionMailer::Base
  default from: "noreply@providechat.com"
  layout 'mailer'

  add_template_helper(EmailHelper)
end
