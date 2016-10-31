class ContactForm < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :subject
  attribute :message

  def headers
    {
      subject: "Provide Chat Contact Form",
      to: "sales@providechat.com",
      from: %("#{name}" <#{email}>)
    }
  end
end
