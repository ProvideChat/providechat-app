source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '5.0.0.1'

gem 'carrierwave', '>= 1.0.0.beta', '< 2.0'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'detect_timezone_rails'
gem 'docverter'
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
#gem 'lograge'
gem 'pg'
#gem 'mail_form'
gem 'mini_magick', '~> 4.5', '>= 4.5.1'
gem "net-ssh"
gem 'nokogiri'
gem 'nprogress-rails'
gem 'paper_trail'
gem 'premailer-rails'
gem 'rails_admin', '>= 1.0.0.rc'
gem 'remotipart', '~> 1.3', '>= 1.3.1'
gem 'sass-rails', '~> 5.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'sidekiq'
gem 'sidekiq-client-cli'
gem 'sinatra', github: 'sinatra', require: false
gem 'slim'
gem 'stackprof'
gem 'stripe', '~> 1.56'
gem 'stripe_event'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'whenever', require: false

source 'https://rails-assets.org' do
  gem 'rails-assets-sweetalert'
end

group :development  do
  gem "flamegraph"
  #gem 'quiet_assets'
  #gem 'rails_best_practices'
  gem 'rack-mini-profiler', require: false

  gem 'capistrano', '~> 3.5.0', require: false
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
  gem 'capybara-webkit', '~> 1.11', '>= 1.11.1'
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
  gem 'web-console'
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

