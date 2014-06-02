class HomeController < ApplicationController
  before_action :authenticate_agent!
end
