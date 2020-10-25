module Api
  module V1
    class AgentsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_agent!, raise: false

      respond_to :json

      def show
        @agent = Agent.find(params[:id])
        @agent.last_seen_at = DateTime.now
        @agent.save

        render json: {'availability': @agent.availability}
      end

      def update
        respond_with Agent.update(params[:id], agent_params)
      end

      private

      def agent_params
        params.require(:agent).permit(:availability)
      end
    end
  end
end
