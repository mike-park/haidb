source 'http://rubygems.org'

gem "rails", "~> 3.0.9"
gem "sqlite3-ruby", :require => "sqlite3"

# include lang in url
gem 'routing-filter'

# handles I18n for dates and times, has bug in fields_changed? which makes fields
# seem to change when they have not
#gem 'delocalize'

gem 'formtastic'
gem "formtastic_datepicker_inputs"
gem 'attrtastic'

# styling support.  the base .scss files have been copied into pubic/stylesheets & edited
gem "activo-rails", :git => 'git://github.com/jellybob/activo-rails.git'

gem "devise", "~> 1.4.2"

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
gem "haml", "~> 3.1.2"
gem 'haml-rails'
gem 'jquery-rails'

# replacement/alternative I18n
gem 'fast_gettext', :git => 'git://github.com/grosser/fast_gettext.git'
gem 'gettext_i18n_rails', :git => 'git://github.com/grosser/gettext_i18n_rails.git'

gem "will_paginate", "~> 3.0.pre2"

group :development, :test do
  gem 'annotate'
  gem 'awesome_print'
  
  gem 'rspec-rails', '~> 2.6.1'
  gem 'factory_girl_rails', '>= 1.1.beta1', :require => false

  gem 'webrat', '>= 0.7.3'

  gem 'spork', '>= 0.9.0.rc2'

  # To use debugger
  gem 'ruby-debug19', :require => 'ruby-debug'

  # heroku interface & taps for db operations
  gem "heroku"
  gem "taps"
end
