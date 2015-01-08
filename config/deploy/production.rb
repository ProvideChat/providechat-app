set :stage, :production
set :branch, "master"

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
#set :server_name, "app.providechat.com"

server '104.131.79.154', user: 'deploy', roles: %w{web app db}, my_property: :my_value

set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:full_app_name)}"

set :rails_env, :production

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{deploy@104.131.79.154}
role :web, %w{deploy@104.131.79.154}
role :db,  %w{deploy@104.131.79.154}



# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options
