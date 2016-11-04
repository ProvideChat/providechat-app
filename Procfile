web:    bundle exec puma -p $PORT -e $RACK_ENV
client: sh -c 'cd client && $(npm bin)/webpack -w --config webpack.rails.config.js'
#component_render_server: supervisor --harmony client/assets/javascripts/component_render_server.js
worker: bundle exec sidekiq
redis:  redis-server /usr/local/etc/redis.conf
mc:     mailcatcher -fv

