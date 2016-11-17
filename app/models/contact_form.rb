class ContactForm < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :subject
  attribute :message

  def headers
    {
      subject: "Provide Chat Contact Form",
      to: "sales@providechat.com",
      from: "noreply@providechat.com",
      reply_to: %("#{name}" <#{email}>)
    }
  end
end
