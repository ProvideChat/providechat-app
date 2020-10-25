require "rails_helper"

RSpec.describe "Chats", type: :request do
  describe "GET /chats" do
    it "works! (now write some real specs)" do
      get chats_path
      expect(response.status).to be(200)
    end
  end
end
