class AgentDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end


  def avatar_img
    h.image_tag avatar_name
  end

  private

  def avatar_name
    if object.avatar_url.present?
      object.avatar_url
    else
      "avatars/silouette.gif"
    end
  end
end
