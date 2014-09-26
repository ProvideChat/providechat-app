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
        visitor.save

        chat = Chat.create(organization_id: @organization.id, website_id: website_id, visitor_id: params[:visitor_id],
                            chat_requested: DateTime.now, visitor_name: params[:name], 
                            visitor_email: params[:email], visitor_department: params[:department], 
                            visitor_question: params[:message], status: "not_started")

        response = {
          'chat_id' => chat.id,
          'html' => render_to_string(partial: 'chat_widget.html.erb', :layout => false, :locals => { :org_id => org_id })
        }

      when "process_offline"
        @organization.process_offline_msg(website_id, params[:name], params[:email], params[:department], params[:message])

      when "get_pre_chat"
        pre_chat_form = PrechatForm.find_by(:website_id => website_id)
        response = {
          'html' => render_to_string(partial: 'pre_chat.html.erb', :layout => false, :locals => { :pre_chat_form => pre_chat_form, :org_id => org_id })
        }
      when "get_in_chat"
        chat_widget = ChatWidget.find_by(:website_id => website_id)
        response = {
          'html' => render_to_string(partial: 'chat_widget.html.erb', :layout => false, :locals => { :chat_widget => chat_widget })
        }
      when "get_offline"
        offline_form = OfflineForm.find_by(:website_id => website_id)
        response = {
          'html' => render_to_string(partial: 'offline_form.html.erb', :layout => false, :locals => { :offline_form => offline_form, :org_id => org_id })
        }
      when "update_status"
        response = { 'agent_status' => @organization.agent_status }
      when "initialize"
        session = JSON.parse(params[:session])
        logger.debug "SESSION DETAILS: #{session}"
        visitor = Visitor.process_session(org_id, session)
        chat_widget = ChatWidget.find_by(:website_id => visitor.website_id)

        if visitor
          response = { 'success' => 'true', 'visitor_id' => visitor.id, 'website_id' => visitor.website_id,
                       'agent_status' => @organization.agent_status, 'agent_response_timeout' => @organization.agent_response_timeout,
                       'chat_id' => 0, 'chat_status' => '', 'visitor_name' => visitor.name, 'online_message' => chat_widget.online_message,
                       'offline_message' => chat_widget.offline_message, 'title_message' => chat_widget.title_message }
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
