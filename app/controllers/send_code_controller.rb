class SendCodeController < ApplicationController
  before_action :authenticate_agent!, raise: false

  def show
    # Rails.logger.info params

    if (params.key?(:webmaster_email) && valid_email?(params[:webmaster_email]))
      # Rails.logger.info "Send email..."
      webmaster_email = params[:webmaster_email]
      SendCodeMailer.send_code(current_agent.organization_id, webmaster_email, current_agent.name).deliver_later
      render json: { status: :ok }
    else
      logger.info "Not sending email..."
      render json: { status: :unprocessable_entity }
    end
  end

  private

  def valid_email?(email)
    email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  end
end
