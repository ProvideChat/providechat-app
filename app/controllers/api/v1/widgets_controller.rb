module Api
  module V1
    class WidgetsController < ApplicationController
      include ActionView::Helpers::DateHelper
      include ActionView::Helpers::SanitizeHelper

      protect_from_forgery with: :null_session

      respond_to :json

      def index

        method = params[:method]
        org_id = params[:org_id]
        website_id = params[:website_id]

        if @organization = Organization.find_by_id(org_id)

          logger.debug "METHOD: #{method}"

          case method
          when "process_pre_chat"
            chat = Chat.create(organization_id: @organization.id, website_id: website_id, visitor_id: params[:visitor_id],
                                chat_requested: DateTime.now, visitor_name: params[:name],
                                visitor_email: params[:email], visitor_department: params[:department],
                                visitor_question: params[:message], status: "not_started")

            visitor = Visitor.find(params[:visitor_id])
            visitor.name = params[:name]
            visitor.email = params[:email]
            visitor.department = params[:department]
            visitor.question = params[:message]
            visitor.status = 'waiting_to_chat';
            visitor.chat_id = chat.id
            visitor.save

            chat_widget = ChatWidget.find_by(:website_id => website_id)
            response = {
              'chat_id' => chat.id,
              'html' => render_to_string(
                          partial: 'chat_widget.html.erb',
                          :layout => false,
                          :locals => { :chat_widget => chat_widget }
                        )
            }

          when "process_invitation"
            chat = Chat.create(organization_id: @organization.id, website_id: website_id, visitor_id: params[:visitor_id],
                                chat_requested: DateTime.now, chat_accepted: DateTime.now,
                                visitor_name: params[:name],
                                visitor_email: '', visitor_department: '',
                                visitor_question: '', status: "in_progress")

            visitor = Visitor.find(params[:visitor_id])
            visitor.name = params[:name]
            visitor.status = 'in_chat';
            visitor.chat_id = chat.id
            visitor.save

            chat.agent_id = visitor.invite_agent_id
            chat.save

            chat_widget = ChatWidget.find_by(:website_id => website_id)

            response = {
              'chat_id' => chat.id,
              'html' => render_to_string(
                          partial: 'chat_widget.html.erb',
                          :layout => false,
                          :locals => { :chat_widget => chat_widget }
                        )
            }

          when "get_chat_messages"

            visitor_id = params[:visitor_id]
            if visitor = Visitor.find(visitor_id)
              visitor.last_ping = DateTime.now
              visitor.save
            end

            if chat = Chat.find(params[:chat_id])
              if params[:context] == 'all'
                chat_messages = ChatMessage.where(chat_id: chat_id)
              elsif params[:context] == 'unseen'
                chat_messages = ChatMessage.where(chat_id: chat_id, seen_by_visitor: false)
              end

              #logger.debug chat_messages
              chat_messages.each do |chat_message|
                chat_message.seen_by_visitor = true
                chat_message.save
              end
              #ChatMessage.where(chat_id: chat_id, seen_by_visitor: false).update_all(seen_by_visitor: true)

              agent_name = "None"
              if chat.agent && chat.agent.display_name
                agent_name = chat.agent.display_name
              end

              response = {
                'status' => chat.status,
                'agent_name' => agent_name,
                'messages' => chat_messages || Array.new,
                'started' => chat.chat_accepted,
                'duration' => chat.chat_ended ? distance_of_time_in_words(chat.chat_accepted, chat.chat_ended) : ''
              }
            else
              response = {
                'success' => 'false'
              }
            end

          when "save_chat_messages"

            messages = params[:messages]

            messages.each do |count, message|
              ChatMessage.create(
                chat_id: message['chat_id'], user_name: message['user_name'], sender: message['sender'],
                seen_by_agent: false, seen_by_visitor: true,
                sent: message['sent'], message: strip_tags(message['message'])
              )
            end

            response = {
              'success' => 'true'
            }

          when "visitor_message"
            visitor_id = params[:visitor_id]
            chat_id = params[:chat_id]
            message = params[:message]
            visitor_name = params[:visitor_name]

            ChatMessage.create(chat_id: chat_id, user_name: visitor_name, sender: "visitor",
                               seen_by_visitor: false, seen_by_agent: false, sent: DateTime.now, message: strip_tags(message))

            response = { 'success' => 'true' }

          when "agent_timeout"
            visitor_id = params[:visitor_id]
            chat_id = params[:chat_id]

            chat = Chat.find(chat_id)
            chat.status = 'agent_timeout'
            chat.chat_ended = DateTime.now
            chat.save

            visitor = Visitor.find(visitor_id)
            visitor.status = 'chat_ended'
            visitor.save

            response = { 'success' => 'true' }

          when "update_visitor_keypress"

            chat_id = params[:chat_id]
            typing = params[:typing]

            chat = Chat.find(chat_id)
            chat.visitor_typing = typing
            chat.save

            response = {
              'chat_id' => chat_id,
              'success' => 'true'
            }

          when "get_agent_typing"

            chat_id = params[:chat_id]

            chat = Chat.find(chat_id)

            response = {
              'chat_id' => chat_id,
              'agent_typing' => chat.agent_typing
            }

          when "update_agent"
            chat_id = params[:chat_id]
            chat = Chat.find(chat_id)

            display_name = ''
            title = ''
            photo_url = 'http://widget.providechat.com/images/silhouette.png'
            if chat.agent
              display_name = chat.agent.display_name
              title = chat.agent.title
              photo_url = chat.agent.avatar_url if chat.agent.avatar?
            end

            response = {
              'chat_status' => chat.status,
              'display_name' => display_name,
              'title' => title,
              'photo_url' => photo_url
            }

          when "process_offline"
            @organization.process_offline_msg(website_id, params[:name], params[:email], params[:department], params[:message])

            response = { 'success' => 'true' }

          when "email_transcript"
            chat_id = params[:chat_id]

            if params.has_key?(:transcript_email) && params[:transcript_email] != ''
              chat = Chat.find(chat_id)
              chat.email_transcript(params[:transcript_email])
            end

            response = { 'success' => 'true' }

          when "end_chat"
            chat_id = params[:chat_id]

            chat = Chat.find(chat_id)
            chat.end_chat('visitor_ended')

            if params.has_key?(:enable_email_transcript) && params[:enable_email_transcript] == 'true' && 
                params.has_key?(:transcript_email) && params[:transcript_email] != ''
              chat.email_transcript(params[:transcript_email])
            end

            response = { 'success' => 'true' }

          when "get_pre_chat"
            pre_chat_form = PrechatForm.find_by(:website_id => website_id)
            response = {
              'html' => render_to_string(
                          partial: 'pre_chat.html.erb',
                          :layout => false,
                          :locals => { :pre_chat_form => pre_chat_form, :org_id => org_id, :website_id => website_id }
                        )
            }

          when "get_invitation"
            visitor = Visitor.find(params[:visitor_id])
            visitor.process_invitation

            agent = Agent.find(visitor.invite_agent_id)
            invitation = Invitation.find_by(:website_id => website_id)
            chat_widget = ChatWidget.find_by(:website_id => website_id)

            response = {
              'html' => render_to_string(
                          partial: 'invitation.html.erb',
                          :layout => false,
                          :locals => { :invitation => invitation, :chat_widget => chat_widget, :agent => agent }
                        )
            }

          when "get_in_chat"
            chat_widget = ChatWidget.find_by(:website_id => website_id)
            response = {
              'html' => render_to_string(
                          partial: 'chat_widget.html.erb',
                          :layout => false,
                          :locals => { :chat_widget => chat_widget }
                        )
            }

          when "get_offline"
            offline_form = OfflineForm.find_by(:website_id => website_id)
            response = {
              'html' => render_to_string(
                          partial: 'offline_form.html.erb',
                          :layout => false,
                          :locals => { :offline_form => offline_form, :org_id => org_id, :website_id => website_id }
                        )
            }

          when "update_status"
            if website = Website.find(website_id)
              website.update_ping
              website.save
            end

            visitor_id = params[:visitor_id]
            visitor = Visitor.find(visitor_id)
            visitor.last_ping = DateTime.now
            visitor.save

            response = { 
              'agent_status' => @organization.agent_status,
              'invite_sent' => visitor.invite_sent
            }

          when "initialize"
            session = JSON.parse(params[:session])
            logger.debug "SESSION DETAILS: #{session}"
            visitor = Visitor.process_session(org_id, session)

            if visitor
              chat_widget = ChatWidget.find_by(:website_id => visitor.website_id)

              chat_id = 0
              chat_status = ''
              if visitor.chat
                chat_id = visitor.chat.id
                chat_status = visitor.chat.status
              end

              response = { 'success' => 'true', 'visitor_id' => visitor.id, 'website_id' => visitor.website_id,
                           'agent_status' => @organization.agent_status, 'agent_response_timeout' => @organization.agent_response_timeout,
                           'chat_id' => chat_id, 'chat_status' => chat_status, 'visitor_name' => visitor.name, 
                           'visitor_email' => visitor.email, 'online_message' => chat_widget.online_message,
                           'offline_message' => chat_widget.offline_message, 'title_message' => chat_widget.title_message,
                           'widget_color' => "\##{chat_widget.color}" }
            else
              response = { 'success' => 'false' }
            end

            logger.debug "RESPONSE DETAILS: #{response}"
          end
        else
          response = { 'success' => 'false' }
        end

        respond_to do |format|
          format.json {
            respond_with response, callback: params[:callback]
          }
        end
      end
    end

  end
end