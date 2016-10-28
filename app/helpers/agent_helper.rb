module AgentHelper
  def avatar_img
    h.image_tag avatar_name
  end

  private

  def avatar_name
    if object.avatar_url.present?
      object.avatar_url
    else
      "silhouette.png"
    end
  end
end
