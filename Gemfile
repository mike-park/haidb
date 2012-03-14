source 'https://rubygems.org'

gem "rake"
gem 'rack'
gem "rails", "3.2.2"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# these add generators that help
gem 'haml', '>= 3.1.4'

# form helpers
gem 'formtastic'
# 2.0 compatible
gem "formtastic_datepicker_inputs", :git => "git://github.com/nurey/formtastic_datepicker_inputs.git"

# attribute display helper
gem "attrtastic"

# include lang in url
gem 'routing-filter'

# handles I18n for dates and times, has bug in fields_changed? which makes fields
# seem to change when they have not
#gem 'delocalize'

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

# template language for emails
gem 'liquid'

# audit tracking of model changes
gem 'acts_as_audited'

# hoptoad error reporting
gem 'hoptoad_notifier'

# replacement/alternative I18n
gem 'fast_gettext', :git => 'git://github.com/grosser/fast_gettext.git'
gem 'gettext_i18n_rails', :git => 'git://github.com/grosser/gettext_i18n_rails.git'

gem "will_paginate"

group :development, :test do
  gem 'sqlite3'
  gem 'annotate'
  gem 'awesome_print'
  gem 'haml-rails'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'spork-rails'
#  gem "autotest", "~> 4.4.6"
#  gem "autotest-rails-pure", "~> 4.1.2"
#  gem "autotest-fsevent", "~> 0.2.5"
#  gem "autotest-growl", "~> 0.2.9"

  # capybara causes rack 1.2.3 to generate warnings
  # rack-1.2.3/lib/rack/utils.rb:16: warning: regexp match /.../n against to UTF-8 string
  # See https://github.com/jnicklas/capybara/issues/243
  # problem fixed with latest rack (which as of 7/7/11 not available for
  # rails 3.0.9
  gem "capybara"
  gem "launchy"
end

group :production do
  gem 'pg'
end
