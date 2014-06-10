require 'rails_helper'

RSpec.describe "ChatWidgets", :type => :request do
  describe "GET /chat_widgets" do
    it "works! (now write some real specs)" do
      get chat_widgets_path
      expect(response.status).to be(200)
    end
  end
end
