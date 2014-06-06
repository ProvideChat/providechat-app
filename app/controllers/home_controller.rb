class HomeController < ApplicationController
  before_action :authenticate_agent!

  def monitor
  end
  
  def dashboard
  end
end
