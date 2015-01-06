class WidgetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  respond_to :json

  def index

    method = params[:method]
    org_id = params[:org_id]
    website_id = params[:website_id]

    if @organization = Organization.find_by_id(org_id)

      logger.debug "METHOD: #{method}"

      case method
      when "process_pre_chat"
        visitor = Visitor.find(params[:visitor_id])
        visitor.name = params[:name]
        visitor.email = params[:email]
        visitor.department = params[:department]
        visitor.question = params[:message]
        visitor.status = 'waiting_to_chat';

        chat = Chat.create(organization_id: @organization.id, website_id: website_id, visitor_id: params[:visitor_id],
                            chat_requested: DateTime.now, visitor_name: params[:name],
                            visitor_email: params[:email], visitor_department: params[:department],
                            visitor_question: params[:message], status: "not_started")

        visitor.chat_id = chat.id
        visitor.save

        response = {
          'chat_id' => chat.id,
          'html' => render_to_string(
                      partial: 'chat_widget.html.erb',
                      :layout => false,
                      :locals => { :org_id => org_id }
                    )
        }

      when "get_chat_messages"
        context = params[:context]
        chat_id = params[:chat_id]

        visitor_id = params[:visitor_id]
        visitor = Visitor.find(visitor_id)
        visitor.last_ping = DateTime.now
        visitor.save

        chat = Chat.find(chat_id)

        if context == 'all'
          chat_messages = ChatMessage.where(chat_id: chat_id)
        elsif context == 'unseen'
          chat_messages = ChatMessage.where(chat_id: chat_id, seen_by_visitor: false)
        end

        #logger.debug chat_messages
        chat_messages.each do |chat_message|
          chat_message.seen_by_visitor = true
          chat_message.save
        end
        #ChatMessage.where(chat_id: chat_id, seen_by_visitor: false).update_all(seen_by_visitor: true)

        response = {
          'status' => chat.status,
          'agent_name' => chat.agent.display_name,
          'messages' => chat_messages || Array.new
        }

      when "visitor_message"
        visitor_id = params[:visitor_id]
        chat_id = params[:chat_id]
        message = params[:message]
        visitor_name = params[:visitor_name]

        ChatMessage.create(chat_id: chat_id, user_name: visitor_name, sender: "visitor",
                           seen_by_visitor: true, seen_by_agent: false, sent: DateTime.now, message: message)

        response = { 'success' => 'true' }

      when "get_key_press_status"
        chat_id = params[:chat_id]

        response = { 'success' => 'true' }

      when "update_agent"
        chat_id = params[:chat_id]
        chat = Chat.find(chat_id)

        display_name = ''
        photo_url = 'http://widget.providechat.com/images/silhouette.png'
        if chat.agent
          display_name = chat.agent.display_name
          photo_url = chat.agent.avatar_url if chat.agent.avatar?
        end

        response = {
          'chat_status' => chat.status,
          'display_name' => display_name,
          'photo_url' => photo_url
        }

      when "process_offline"
        @organization.process_offline_msg(website_id, params[:name], params[:email], params[:department], params[:message])

      when "end_chat"
        chat_id = params[:chat_id]

        chat = Chat.find(chat_id)
        chat.end_chat('visitor_ended')

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

        response = { 'agent_status' => @organization.agent_status }
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
                       'chat_id' => chat_id, 'chat_status' => chat_status, 'visitor_name' => visitor.name, 'online_message' => chat_widget.online_message,
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
