class ChatMailer < ApplicationMailer

  def email_transcript(chat_id, recipient_email)
    @chat = Chat.find(chat_id)

    if @chat.chat_messages.count > 0
      @text_transcript = ""
      @html_transcript = ""

      last_user_name = ""
      @chat.chat_messages.each do |chat_message|
        text_msg += " - #{chat_message.user_name}: #{chat_message.message}\n\n"
        if chat_message.user_name != last_user_name
          @html_transcript += "<br><strong>#{chat_message.user_name}:</strong><br>"
          @text_transcript += "#{chat_message.user_name}:\n"
        end
        @html_transcript += "#{chat_message.message}<br>"
        @text_transcript += " - #{chat_message.message}\n\n"
        last_user_name = chat_message.user_name
      end

      mail(to: recipient_email, subject: "Your Provide Chat Transcript")
    end
  end
end
