set :stage, :staging
set :branch, "staging"

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
#set :server_name, "app.providechat.com"

server '104.131.79.154', user: 'deploy', roles: %w{web app}, my_property: :my_value

set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:full_app_name)}"

set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:full_app_name)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"

set :rails_env, :staging
