module Api
  module V1
    class ChatMonitorController < ApplicationController
      include ActionView::Helpers::DateHelper
      include ActionView::Helpers::SanitizeHelper

      skip_before_action :verify_authenticity_token
      before_action :authenticate_agent!, raise: false

      respond_to :json

      def update
        #chat_id = params[:id]

        method = params[:method]
        org_id = current_agent.organization_id

        if @organization = Organization.find_by_id(org_id)

          logger.debug "METHOD: #{method}"

          case method
          when "accept_chat"

          else
            #response = { 'success' => 'false' }
          end
        end
        respond_with Agent.update(params[:id], agent_params)
      end

      def index

        method = params[:method]
        org_id = current_agent.organization_id

        if @organization = Organization.find_by_id(org_id)

          logger.info "METHOD: #{method}"

          case method
          when "accept_chat"
            agent_id = params[:agent_id]
            agent_name = params[:agent_name]
            visitor_id = params[:visitor_id]

            agent = Agent.find(agent_id)
            if agent.organization.account_type == 'free' && 
                agent.chats.where(status: Chat.statuses[:in_progress]).count >= 1
                
              visitor = Visitor.find(visitor_id)
              
              chat = Chat.find(visitor.chat.id)
              chat.agent_id = agent_id
              chat.status = 'agent_timeout'
              chat.chat_accepted = DateTime.now
              chat.save

              response = {
                'chat_id' => 0,
                'status' => 'max_chats'
              }
            else
              visitor = Visitor.find(visitor_id)
              visitor.status = 'in_chat'
              visitor.save

              chat = Chat.find(visitor.chat.id)
              chat.agent_id = agent_id
              chat.status = 'in_progress'
              chat.chat_accepted = DateTime.now
              chat.save

              if visitor.question.length > 0
                ChatMessage.create(chat_id: chat.id, user_name: visitor.name, sender: "visitor",
                              seen_by_visitor: false, seen_by_agent: false, sent: DateTime.now,
                              message: visitor.question)
              end

              response = {
                'chat_id' => chat.id,
                'visitor_id' => visitor_id,
                'visitor_name' => chat.visitor_name,
                'status' => 'accepted'
              }
            end

          when "get_chat_tab"
            chat_id = params[:chat_id]
            visitor_id = params[:visitor_id]
            visitor_name = params[:visitor_name]
            chat_status = params[:chat_status]

            response = {
              'chat_id' => chat_id,
              'visitor_id' => visitor_id,
              'visitor_name' => visitor_name,
              'chat_status' => chat_status,
              'html' => render_to_string(
                partial: 'chat_tab.html.erb',
                layout: false,
                locals: {
                  chat_id: chat_id,
                  visitor_name: visitor_name,
                  visitor_id: visitor_id
                }
              )
            }

          when "get_chat_messages"
            context = params[:context]
            chat_id = params[:chat_id]
            agent_id = params[:agent_id]
            #last_message_id = params[:last_message_id]

            chat = Chat.find(chat_id)

            if context == 'all'
              chat_messages = ChatMessage.where(chat_id: chat_id).order(:sent)
            else
              chat_messages = ChatMessage.where(chat_id: chat_id, seen_by_agent: false).order(:sent)
            end

            # chat_messages = ChatMessage.where(chat_id: chat_id).where("id > ?", last_message_id).order(:id)
            # Rails.logger.info "GET_CHAT_MESSAGES: GETTING '#{context}' MESSAGES"

            chat_messages.each do |chat_message|
              chat_message.seen_by_agent = true
              chat_message.save
            end

            # ChatMessage.where(chat_id: chat_id, seen_by_agent: false).update_all(seen_by_agent: true)

            response = {
              'status' => chat.status,
              'chat_id' => chat.id,
              'ticket_id' => chat.ticket_id,
              'visitor_name' => chat.visitor_name,
              'messages' => chat_messages || Array.new,
              'started' => chat.chat_accepted,
              'duration' => chat.chat_ended ? distance_of_time_in_words(chat.chat_accepted, chat.chat_ended) : ''
            }

          when "get_current_chats"
            agent_id = params[:agent_id]

            current_chats = Chat.where(agent_id: agent_id, status: '1')

            response = {
              'current_chats' => current_chats || Array.new
            }

          when "update_agent_keypress"

            chat_id = params[:chat_id]
            typing = params[:typing]

            chat = Chat.find(chat_id)
            chat.agent_typing = typing
            chat.save

            response = {
              'chat_id' => chat_id,
              'success' => 'true'
            }

          when "get_visitor_typing"

            chat_id = params[:chat_id]

            chat = Chat.find(chat_id)

            response = {
              'chat_id' => chat_id,
              'visitor_name' => chat.visitor_name,
              'visitor_typing' => chat.visitor_typing
            }

          when "send_chat_invite"

            visitor_id = params[:visitor_id]
            agent_id = params[:agent_id]

            agent = Agent.find(agent_id)
            if agent.organization.account_type == 'free' && 
                agent.chats.where(status: Chat.statuses[:in_progress]).count >= 1
              response = {
                'success' => 'max_chats'
              }
            else            
              visitor = Visitor.find(visitor_id)
              visitor.agent_invite_status = 'agent_sent'
              visitor.invite_agent_id = agent_id
              visitor.save

              response = {
                'visitor_id' => visitor_id,
                'success' => 'invited'
              }
            end

          when "save_chat_messages"

            messages = params[:messages]

            messages.each do |count, message|
              ChatMessage.create(
                chat_id: message['chat_id'], user_name: message['user_name'], sender: message['sender'],
                seen_by_agent: true, seen_by_visitor: false,
                sent: message['sent'], message: strip_tags(message['message'])
              )
            end

            response = {
              'success' => 'true'
            }

          when "agent_message"
            agent_id = params[:agent_id]
            chat_id = params[:chat_id]
            message = params[:message]
            agent_name = params[:agent_name]

            ChatMessage.create(chat_id: chat_id, user_name: agent_name, sender: "agent", seen_by_agent: false,
                               seen_by_visitor: false, sent: DateTime.now, message: strip_tags(message))

            response = {
              'chat_id' => chat_id,
              'success' => 'true'
            }

          when "end_chat"
            chat_id = params[:chat_id]

            chat = Chat.find(chat_id)
            chat.end_chat('agent_ended')

            response = {
              'chat_id' => chat_id,
              'success' => 'true'
            }
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
