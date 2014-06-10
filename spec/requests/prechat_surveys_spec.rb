require 'rails_helper'

RSpec.describe "PrechatSurveys", :type => :request do
  describe "GET /prechat_surveys" do
    it "works! (now write some real specs)" do
      get prechat_surveys_path
      expect(response.status).to be(200)
    end
  end
end
