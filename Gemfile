source 'http://rubygems.org'

gem "rails", "~> 3.0.9"
gem "sqlite3-ruby", :require => "sqlite3"

# my specials
gem 'routing-filter'
# handles I18n for dates and times, has bug in fields_changed? which makes fields
# seem to change when they have not
#gem 'delocalize'
gem 'tabletastic', '~> 0.2.0.pre6'
gem 'formtastic'
gem 'attrtastic'
#gem "tabs_on_rails"
gem "activo-rails", :git => 'git://github.com/mikepinde/activo-rails.git'
gem "formtastic_datepicker_inputs"

gem "devise", ">= 1.1.3"
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

# simple model searching
gem "meta_search"
# vcard export
gem 'vcard'
# geocoding angel
gem "geocoder", :git => 'git://github.com/mikepinde/geocoder.git'
#gem "geocoder", :path => "~/src/ruby/git/geocoder"
# country select list
gem 'carmen', :git => 'git://github.com/mikepinde/carmen.git'
# pdf export
gem 'prawn'

# xls export
# dont use
# Office::RegistrationsController# (ActionView::Template::Error) "incompatible character encodings: ASCII-8BIT and US-ASCII"
#gem "ekuseru"

# audit tracking of model changes
gem 'acts_as_audited', :git => 'git://github.com/collectiveidea/acts_as_audited.git'

# hoptoad error reporting
gem 'hoptoad_notifier'

# these add generators that help
gem 'haml-rails'
gem 'jquery-rails'

# replacement/alternative I18n
gem 'fast_gettext', :git => 'git://github.com/grosser/fast_gettext.git'
gem 'gettext_i18n_rails', :git => 'git://github.com/grosser/gettext_i18n_rails.git'

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
  gem 'annotate'
  gem 'awesome_print'
  
  gem 'rspec-rails', '>= 2.4.1'
  gem 'factory_girl_rails', '>= 1.1.beta1', :require => false

  gem 'webrat', '>= 0.7.3'

  gem 'spork', '>= 0.9.0.rc2'
  gem 'metric_fu', '>= 2.0.1'

  # To use debugger
  gem 'ruby-debug19', :require => 'ruby-debug'

  # heroku interface & taps for db operations
  gem "heroku"
  gem "taps"
end
