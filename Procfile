web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec sidekiq -e production -i 0 -q critical -q default
clock: bundle exec clockwork clock.rb