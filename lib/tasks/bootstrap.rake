namespace :db do
  desc 'Starting from a fresh install, get your database up and running'
  task :bootstrap => :environment do
    if ActiveRecord::Base.connection.execute( "SELECT * FROM pg_stat_activity" ).count > 1
      puts "You must shut down all other database connections (server, console, etc.) before bootstrapping.".red
      exit
    end

    puts "About to bootstrap your database.".yellow
    puts "This means wiping everything out and starting from scratch.".yellow
    puts "Are you sure you want to do this? (y/n)".red
    puts "(NOTE: This will auto-accept after 10 seconds.)".red
    results = IO.select [STDIN], nil, nil, 10 

    results = results.try(:first).try(:first)

    if results.nil? || (results.read(1) == "y")
      puts "Beginning bootstrap"

      puts 'Step 1. Dropping database'
      Rake::Task["db:drop"].execute

      puts 'Step 2. Creating empty database'
      Rake::Task["db:create"].execute

      puts 'Step 3. Restoring from development database dump file.'
      #config = ActiveRecord::Base.configurations[Rails.env]
      #ENV['PGPASSWORD'] = config["password"]
      #`pg_restore --verbose --clean --no-acl --no-owner -h localhost -U #{config["username"]} -d desiringgod_development db/dumps/sanitized.dump`

      puts 'Step 4. Migrating database'
      Rake::Task["db:migrate"].execute

      puts 'Step 5. Seed the development database'
      Rake::Task["db:seed"].invoke

      puts 'Step 6. Preparing the test database'
      Rake::Task["db:test:prepare"].execute
    else
      puts "Aborting".red
    end
  end
end
