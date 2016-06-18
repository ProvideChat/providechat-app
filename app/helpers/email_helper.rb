module EmailHelper
  def email_image_tag(image, **options)
    attachments[image] = File.read(Rails.root.join("app/assets/images/#{image}"))
    image_tag attachments[image].url, **options
  end

  def formatted_price(amount)
    sprintf("$%0.2f", (amount || 0) / 100.0)
  end
end
