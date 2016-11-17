Airbrake.configure do |config|
  config.host = 'https://providechat-errbit.herokuapp.com'
  config.project_id = 1 # required, but any positive integer works
  config.project_key = ENV['errbit_project_key']

  # Uncomment for Rails apps
  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end
