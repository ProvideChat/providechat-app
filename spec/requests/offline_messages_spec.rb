require 'rails_helper'

RSpec.describe "OfflineMessages", :type => :request do
  describe "GET /offline_messages" do
    it "works! (now write some real specs)" do
      get offline_messages_path
      expect(response.status).to be(200)
    end
  end
end
