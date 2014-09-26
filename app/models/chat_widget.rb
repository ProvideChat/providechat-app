class ChatWidget < ActiveRecord::Base
  belongs_to :organization
  belongs_to :website
  before_create :set_defaults

  def self.color_options
    {
      "Dark" => "#3B3B3B",
      "Black" => "#111111",
      "Green" => "#7bd148",
      "Bold blue" => "#5484ed",
      "Blue" => "#a4bdfc",
      "Turquoise" => "#46d6db",
      "Light green" => "#7ae7bf",
      "Bold green" => "#51b749",
      "Yellow" => "#fbd75b",
      "Orange" => "#ffb878",
      "Red" => "#ff887c",
      "Bold red" => "#dc2127",
      "Purple" => "#dbadff",
      "Gray" => "#e1e1e1"
    }
  end

  private
    def set_defaults
      self.online_message = 'Chat Now'
      self.offline_message = 'Send A Message'
      self.title_message = 'Welcome to Provide Chat'
      self.color = '#3B3B3B'
      self.display_logo = true
      self.display_agent_avatar = true
      self.display_mobile_icon = true
    end
end
