require 'rubygems'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "pundit/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.use_transactional_fixtures = true
  config.include FactoryGirl::Syntax::Methods

  # my login macros; available in describe not it
  config.extend ControllerMacros, :type => :controller

  config.include CapybaraMacros, :type => :request
end

=begin
  # useful way to figure out time spent in requires
  # module Kernel
  #   def require_with_trace(*args)
  #     start = Time.now.to_f
  #     @indent ||= 0
  #     @indent += 2
  #     require_without_trace(*args)
  #     @indent -= 2
  #     Kernel::puts "#{' '*@indent}#{((Time.now.to_f - start)*1000).to_i} #{args[0]}"
  #   end
  #   alias_method_chain :require, :trace
  # end
=end
