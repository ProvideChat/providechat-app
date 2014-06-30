class WidgetsController < ApplicationController
  layout false
  
  def index

    method = params[:method]
    org_id = params[:org_id]
    website_id = params[:website_id]

    @organization = Organization.find(org_id)
    
    logger.debug "METHOD: #{method}"
    
    case method
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
    when "initialize"
      logger.debug "SESSION DETAILS: #{params[:session]}"
      visitor = Visitor.process_session(org_id, params[:session])
      
      response = { 'visitor_id' => visitor.id, 'website_id' => visitor.website_id, 
                   'operator_status' => 'offline', 'operator_response_timeout' => 5,
                   'chat_id' => 0, 'chat_status' => '', 'visitor_name' => visitor.name }
    end
    
    respond_to do |format|
      format.json {
        #search = Search.new(q: params[:q], per: params[:limit])
        #render json: search.events, callback: params[:callback]

        render json: response, callback: params[:callback]
      }
    end
  end
  
  
end
