# Minimal Heroku unicorn config
# I found no real gain from preload_app=true on Heroku
# Heroku has a 30s timeout so we enforce the same
# Depending on memory usage workers can be bumped to 3-4
# preload_app=true can cause issues if you don't reconnect things correctly
worker_processes 3
timeout 30