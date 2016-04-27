source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.6'

gem 'ancestry'
gem 'carrierwave'
gem 'coffee-rails', '~> 4.1.0'
gem 'devise'
gem 'devise-async'
gem 'draper', '~> 1.3'
gem 'exception_notification'
gem 'feedjira'
gem 'fog'
gem 'font-awesome-rails'
gem 'haml'
gem 'htmlentities'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'json'
gem 'local_time'
#gem 'lograge'
gem 'pg'
gem 'mail_form'
gem 'mandrill-api'
gem 'mini_magick', '~> 4.0.0.rc'
gem "net-ssh"
gem 'nprogress-rails'
gem 'paper_trail', '~> 4.0.0.beta'
gem 'sass-rails', '~> 5.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'sidekiq'
gem 'sidekiq-client-cli'
gem 'sinatra', :require => nil
gem 'stackprof'
gem 'stripe', '~> 1.31.0'
gem 'stripe_event'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'whenever', require: false

source 'https://rails-assets.org' do
  gem 'rails-assets-sweetalert'
  gem 'rails-assets-moment'
  gem 'rails-assets-moment-timezone'
end

group :development  do
  gem "flamegraph"
  gem 'quiet_assets'
  gem 'rails_best_practices'
  gem 'rack-mini-profiler', require: false

  gem 'capistrano', '~> 3.4.0', require: false
  gem 'capistrano-bundler',     require: false
  gem 'capistrano-rails',       require: false
  gem 'capistrano-rbenv',       require: false
  gem 'capistrano3-puma',       require: false
end

group :test, :development do 
  gem 'annotate'
  gem 'binding_of_caller'
  gem 'bundler-audit'
  gem 'brakeman', require: false
  gem 'byebug'
  gem 'capybara'
  gem 'capybara-webkit', git: 'https://github.com/thoughtbot/capybara-webkit.git'
  gem 'capybara-email'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'rspec-rails'

  gem 'pry'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'pry-rails'

  gem 'stripe-ruby-mock'
  #gem 'spring'
  #gem 'spring-commands-rspec'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem "timecop"
  gem "webmock"
end

gem 'puma'

