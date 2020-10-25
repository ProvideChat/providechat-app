Airbrake.configure do |config|
  config.host = "https://providechat-errbit.herokuapp.com"
  config.project_id = 1 # required, but any positive integer works
  config.project_key = ENV["ERRBIT_PROJECT_KEY"]

  # Uncomment for Rails apps
  config.environment = Rails.env
  config.ignore_environments = %w[development test]
end
