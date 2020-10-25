require "net/smtp"

module Net
  class SMTP
    def tls?
      Rails.env.production? ? true : false
    end
  end
end
