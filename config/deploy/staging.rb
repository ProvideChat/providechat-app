set :stage, :staging
set :branch, "staging"

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
#set :server_name, "app.providechat.com"

server '104.131.79.154', user: 'deploy', roles: %w{web app}, my_property: :my_value

set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:full_app_name)}"

set :rails_env, :staging