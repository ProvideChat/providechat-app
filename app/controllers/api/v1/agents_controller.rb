module Api
  module V1
    class AgentsController < ApplicationController
      skip_before_action :verify_authenticity_token
      #before_filter :restrict_access

      respond_to :json

      def update
        respond_with Agent.update(params[:id], agent_params)
      end

    private

    def set_agent
      @agent = Agent.find(params[:id])
    end

      def restrict_access
        authenticate_or_request_with_http_token do |token, options|
          ApiKey.exists?(access_token: token)
        end
      end

      def agent_params
        params.require(:agent).permit(:availability)
      end
    end
  end
end
