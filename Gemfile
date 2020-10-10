# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.7.1'

gem 'rails', '5.2.3'

gem 'airbrake', '~> 6.2'
gem 'carrierwave', '~> 2.0'
gem 'coffee-rails'
gem 'detect_timezone_rails'
gem 'devise'
gem 'docverter'
gem 'exception_notification'
gem 'feedjira'
gem 'fog'
gem "foreman"
gem 'haml'
gem 'htmlentities'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'json'
gem 'mail_form'
gem 'mini_magick'
gem "net-ssh"
gem 'nokogiri'
gem 'nprogress-rails'
gem 'paper_trail'
gem 'pg'
gem 'premailer-rails'
gem 'rails-assets-sweetalert2', source: 'https://rails-assets.org'
gem 'rails_admin', '~> 2.0'
gem 'remotipart', '~> 1.3', '>= 1.3.1'
gem 'sass-rails'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'sidekiq'
gem 'sidekiq-client-cli'
gem 'sinatra', '~> 2.0.2'
gem 'slim'
gem 'stackprof'
gem 'stripe', '~> 1.56'
gem 'stripe_event'
gem 'uglifier', '>= 1.3.0'
gem 'whenever', require: false

group :development do
  gem "flamegraph"

  gem 'rack-mini-profiler', require: false

  gem 'capistrano', '~> 3.5.0', require: false
  gem 'capistrano-bundler',     require: false
  gem 'capistrano-rails',       require: false
  gem 'capistrano-rbenv',       require: false
  gem 'capistrano3-puma',       require: false

  gem 'web-console'
end

group :test, :development do
  gem 'annotate'
  gem 'binding_of_caller'
  gem 'brakeman', require: false
  gem 'bundler-audit'
  gem 'byebug'
  gem 'capybara'
  # gem 'capybara-webkit'
  gem 'capybara-email'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'rspec-rails'

  gem 'rails_best_practices'
  gem 'rubocop', require: false

  gem 'pry'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'

  gem 'stripe-ruby-mock'
  # gem 'spring'
  # gem 'spring-commands-rspec'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem "timecop"
end

gem 'puma'
