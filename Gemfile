source 'http://rubygems.org'

gem "rails", "~> 3.0.0"
gem "sqlite3-ruby", :require => "sqlite3"

# my specials
gem 'routing-filter'
gem 'delocalize'
gem 'tabletastic', '~> 0.2.0.pre6'
gem 'formtastic'
gem 'attrtastic'
#gem "tabs_on_rails"
gem "activo-rails", :git => 'git://github.com/mikepinde/activo-rails.git'
gem "formtastic_datepicker_inputs"

gem "devise", ">= 1.1.3"
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

gem "meta_search"
gem 'vcard'
gem "rails-geocoder", :require => "geocoder", :git => 'git://github.com/alexreisner/geocoder.git'
gem 'carmen', :git => 'git://github.com/mikepinde/carmen.git'
gem 'prawn', :git => 'git://github.com/sandal/prawn.git', :submodules => true

# these add generators that help
gem 'haml-rails'
gem 'jquery-rails'


# prologue standards
#gem "cancan"
#gem "hoptoad_notifier"
#gem "jammit"
#gem "friendly_id", "~> 3.1"
gem "will_paginate", "~> 3.0.pre2"
gem "haml", ">= 3.0.21"
gem "rails3-generators", :group => :development
gem "hpricot", :group => :development
gem "ruby_parser", :group => :development
#gem "rspec-rails", "~> 2.0.0", :group => [:test, :development]
#gem "mocha", :group => [:test]
#gem "factory_girl_rails", :group => [:test, :cucumber]
#gem "faker", "= 0.3.1", :group => [:development, :test]
#gem "autotest", :group => [:test]
#gem "autotest-rails", :group => [:test]
#gem "thin", :group => [:test, :cucumber, :development]
#gem "cucumber", :group => [:cucumber]
#gem "database_cleaner", :group => [:test, :cucumber]
#gem "cucumber-rails", :group => [:cucumber]
#gem "capybara", "0.4.0", :group => [:cucumber]
#gem "launchy", :group => [:cucumber]
#gem "timecop", :group => [:test, :cucumber]
#gem "pickle", :group => [:test, :cucumber]

# Deploy with Capistrano
# gem 'capistrano'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  # newer version fails for me.
  gem "faker", "= 0.3.1", :group => [:development, :test]
  gem 'annotate-models'
  gem 'awesome_print'
  
  gem 'rspec-rails', '>= 2.4.1'
  gem 'factory_girl_rails', '>= 1.1.beta1', :require => false

  gem 'webrat', '>= 0.7.3'

  gem 'spork', '>= 0.9.0.rc2'
  gem 'metric_fu', '>= 2.0.1'

  # To use debugger
  #   gem 'ruby-debug19', :require => 'ruby-debug'
end
