# Load DSL and Setup Up Stages
require "capistrano/setup"

# Includes default deployment tasks
require "capistrano/deploy"

require "capistrano/bundler"
require "capistrano/rbenv"
require "capistrano/rails"
require "capistrano/puma"
require "capistrano/puma/nginx"

set :rbenv_type, :user
set :rbenv_ruby, "2.4.1"

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob("lib/capistrano/tasks/*.cap").each { |r| import r }
