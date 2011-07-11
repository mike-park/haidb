require 'spork'

# setup with help from:
# http://www.arailsdemo.com/posts/35

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    # my login macros; available in describe not it
    config.extend ControllerMacros, :type => :controller
    config.extend CapybaraMacros, :type => :request
  end

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

end

Spork.each_run do
  require 'factory_girl_rails'
end

# allow us to change models without reloading spork
# this does not work this app & rails 3.0.9.  i have used it with a
# different app & rails 3.1rc4 with no problems
#Spork.each_run do
#  ActiveSupport::Dependencies.clear
#  ActiveRecord::Base.instantiate_observers
#end if Spork.using_spork?
