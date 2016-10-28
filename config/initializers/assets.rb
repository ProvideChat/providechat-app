# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")
Rails.application.config.assets.precompile += [ '.json', '.svg', '.eot', '.woff', '.ttf', '.png', '.jpg' ]
Rails.application.config.assets.precompile += %w( modernizr.js smartadmin.config.js smartadmin.js jarvis.widget.js )
Rails.application.config.assets.precompile += %w( smart-notification.js select2.js bootstrap-touchspin.js )
Rails.application.config.assets.precompile += %w( monitor.js jquery.bootstrap.wizard.js wizard.js )
Rails.application.config.assets.precompile += %w( bootstrap.css smartadmin-production-plugins.css mailer.css )
Rails.application.config.assets.precompile += %w( smartadmin-production.css bootstrap-touchspin.css gsdk-base.css)

