require 'rails_helper'

RSpec.describe "RapidResponses", :type => :request do
  describe "GET /rapid_responses" do
    it "works! (now write some real specs)" do
      get rapid_responses_path
      expect(response.status).to be(200)
    end
  end
end
