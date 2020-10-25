require "rails_helper"

RSpec.describe RapidResponsesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/rapid_responses").to route_to("rapid_responses#index")
    end

    it "routes to #new" do
      expect(get: "/rapid_responses/new").to route_to("rapid_responses#new")
    end

    it "routes to #show" do
      expect(get: "/rapid_responses/1").to route_to("rapid_responses#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/rapid_responses/1/edit").to route_to("rapid_responses#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/rapid_responses").to route_to("rapid_responses#create")
    end

    it "routes to #update" do
      expect(put: "/rapid_responses/1").to route_to("rapid_responses#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/rapid_responses/1").to route_to("rapid_responses#destroy", id: "1")
    end
  end
end
