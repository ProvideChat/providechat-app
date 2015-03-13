# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'providechat-app'
set :deploy_user, 'deploy'

set :scm, :git
set :repo_url, 'git@bitbucket.org:providechat/providechat-app'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml .rbenv-vars}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []


# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
  after :finishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

# For capistrano 3
namespace :sidekiq do
  task :quiet do
    # Horrible hack to get PID without having to use terrible PID files
    puts capture("kill -USR1 $(sudo initctl status workers | grep /running | awk '{print $NF}') || :") 
  end
  task :restart do
    execute :sudo, :initctl, :restart, :workers
  end
end

after 'deploy:starting', 'sidekiq:quiet'
after 'deploy:reverted', 'sidekiq:restart'
after 'deploy:published', 'sidekiq:restart'

# If you wish to use Inspeqtor to monitor Sidekiq
# https://github.com/mperham/inspeqtor/wiki/Deployments
namespace :inspeqtor do
  task :start do
    execute :inspeqtorctl, :start, :deploy
  end
  task :finish do
    execute :inspeqtorctl, :finish, :deploy
  end
end

before 'deploy:starting', 'inspeqtor:start'
after 'deploy:finished', 'inspeqtor:finish'
