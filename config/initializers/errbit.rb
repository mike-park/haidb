Airbrake.configure do |config|
  config.api_key		= ENV['AIRBRAKE_KEY']
  config.host				= 'mp-airbrake.herokuapp.com'
  config.port				= 443
  config.secure			= config.port == 443
  config.http_open_timeout = 10
  config.http_read_timeout = 10
end
