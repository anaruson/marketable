require './app/workers/workers.rb'
Sidekiq.default_worker_options = { backtrace: 5 }
