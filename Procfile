web:    bundle exec puma -p $PORT -e $RACK_ENV
worker: bundle exec sidekiq
redis:  redis-server /usr/local/etc/redis.conf
mc:     mailcatcher -fv

