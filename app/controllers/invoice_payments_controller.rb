class InvoicePaymentsController < ApplicationController
  before_action :authenticate_agent!, raise: false
  before_action :validate_superadmin

  def index
    @invoice_payments = InvoicePayment.where(
      organization_id: current_agent.organization_id
    ).order("created_at")
  end

  def show
    @invoice_payment = InvoicePayment.find(params[:id])
  end

  private

  def validate_superadmin
    unless current_agent.access_level == "superadmin"
      redirect_to monitor_path
    end
  end
end
