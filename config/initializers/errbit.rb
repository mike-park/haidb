HoptoadNotifier.configure do |config|
  config.api_key = ENV['HAIDB_HOPTOAD_KEY']
  config.host    = ENV['HAIDB_HOPTOAD_HOST']
  config.port    = 443
  config.secure  = config.port == 443
end
