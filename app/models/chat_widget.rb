class ChatWidget < ActiveRecord::Base
  belongs_to :organization
  belongs_to :website

  before_create :set_defaults
  before_update :smart_color_update

  mount_uploader :logo, LogoUploader

  def process_update(params, chat_widget_params)
    if params.has_key?(:restore_defaults)
      self.set_defaults
      self.save
      "Your chat widget was reset to default settings."
    elsif params.has_key?(:save_changes)
      self.update(chat_widget_params)
      self.save
      "Your chat widget was successfully updated."
    else
      "Your changes were cancelled"
    end
  end

  def self.color_options
    {
      "#ffffff" => "ffffff",
      "#ffccc9" => "ffccc9",
      "#ffce93" => "ffce93",
      "#fffc9e" => "fffc9e",
      "#ffffc7" => "ffffc7",
      "#9aff99" => "9aff99",
      "#96fffb" => "96fffb",
      "#cdffff" => "cdffff",
      "#cbcefb" => "cbcefb",
      "#cfcfcf" => "cfcfcf",
      "#fd6864" => "fd6864",
      "#fe996b" => "fe996b",
      "#fffe65" => "fffe65",
      "#fcff2f" => "fcff2f",
      "#67fd9a" => "67fd9a",
      "#38fff8" => "38fff8",
      "#68fdff" => "68fdff",
      "#9698ed" => "9698ed",
      "#c0c0c0" => "c0c0c0",
      "#fe0000" => "fe0000",
      "#f8a102" => "f8a102",
      "#ffcc67" => "ffcc67",
      "#f8ff00" => "f8ff00",
      "#34ff34" => "34ff34",
      "#68cbd0" => "68cbd0",
      "#34cdf9" => "34cdf9",
      "#6665cd" => "6665cd",
      "#9b9b9b" => "9b9b9b",
      "#cb0000" => "cb0000",
      "#f56b00" => "f56b00",
      "#ffcb2f" => "ffcb2f",
      "#ffc702" => "ffc702",
      "#32cb00" => "32cb00",
      "#00d2cb" => "00d2cb",
      "#3166ff" => "3166ff",
      "#6434fc" => "6434fc",
      "#656565" => "656565",
      "#9a0000" => "9a0000",
      "#ce6301" => "ce6301",
      "#cd9934" => "cd9934",
      "#999903" => "999903",
      "#009901" => "009901",
      "#329a9d" => "329a9d",
      "#3531ff" => "3531ff",
      "#6200c9" => "6200c9",
      "#343434" => "343434",
      "#680100" => "680100",
      "#963400" => "963400",
      "#986536" => "986536",
      "#646809" => "646809",
      "#036400" => "036400",
      "#34696d" => "34696d",
      "#00009b" => "00009b",
      "#303498" => "303498",
      "#000000" => "000000",
      "#330001" => "330001",
      "#643403" => "643403",
      "#663234" => "663234",
      "#343300" => "343300",
      "#013300" => "013300",
      "#003532" => "003532",
      "#010066" => "010066",
      "#340096" => "340096"
    }
  end

  protected

  def smart_color_update
    self.color = self.color.sub(/^\#/, '')
  end

  def set_defaults
    self.online_message = 'Chat Now'
    self.offline_message = 'Send A Message'
    self.title_message = 'Welcome to Provide Chat'
    self.color = '3B3B3B'
    self.display_logo = true
    self.display_agent_avatar = true
    self.display_mobile_icon = true
  end
end
