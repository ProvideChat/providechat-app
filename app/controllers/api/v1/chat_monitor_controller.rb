module Api
  module V1
    class ChatMonitorController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_agent!

      respond_to :json

      def update
        chat_id = params[:id]

        method = params[:method]
        org_id = current_agent.organization_id
        
        if @organization = Organization.find_by_id(org_id)

          logger.debug "METHOD: #{method}"

          case method
          when "accept_chat"

          else
            response = { 'success' => 'false' }
          end
          end
        respond_with Agent.update(params[:id], agent_params)
      end

      def index

        method = params[:method]
        org_id = current_agent.organization_id

        if @organization = Organization.find_by_id(org_id)

          logger.debug "METHOD: #{method}"

          case method
          when "accept_chat"
            chat_id = params[:chat_id]
            agent_id = params[:agent_id]
            visitor_id = params[:visitor_id]

            chat = Chat.find(chat_id)
            chat.agent_id = agent_id
            chat.status = 'in_progress'
            chat.chat_accepted = DateTime.now
            chat.save

            response = {
              'chat_id' => chat.id,
              'visitor_id' => visitor_id,
              'visitor_name' => chat.visitor_name
            }

          when "get_messages"


          else
            response = { 'success' => 'false' }
          end

          logger.debug "RESPONSE DETAILS: #{response}"
        else
          response = { 'success' => 'false' }
        end

        respond_to do |format|
          format.json {
            respond_with response
          }
        end
      end
    end
  end
end
