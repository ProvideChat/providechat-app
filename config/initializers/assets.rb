Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")
Rails.application.config.assets.precompile += [ '.json', '.svg', '.eot', '.woff', '.ttf', '.png', '.jpg' ]
Rails.application.config.assets.precompile += %w( modernizr.js smartadmin.config.js smartadmin.js jarvis.widget.js )
Rails.application.config.assets.precompile += %w( smart-notification.js select2.js bootstrap-touchspin.js )
Rails.application.config.assets.precompile += %w( monitor.js jquery.bootstrap.wizard.js wizard.js )
Rails.application.config.assets.precompile += %w( bootstrap.css smartadmin-production-plugins.css )
Rails.application.config.assets.precompile += %w( smartadmin-production.css bootstrap-touchspin.css gsdk-base.css)