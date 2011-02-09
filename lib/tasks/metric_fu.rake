# avoid needing this on heroku
if ENV['RACK_ENV'] != 'production'
  # metric_fu.rake
  require 'metric_fu'   # gives the 'rake metrics:all' command
  MetricFu::Configuration.run do |config|
    config.rcov[:test_files] = ['spec/**/*_spec.rb']
    config.rcov[:rcov_opts] << "-Ispec" # Needed to find spec_helper
  end
end

