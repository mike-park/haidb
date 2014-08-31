source 'https://rubygems.org'
source 'https://rails-assets.org'

ruby '2.0.0'
gem "rake"
gem 'rack'
gem "rails", '4.1.0'
gem 'unicorn'         # web server
gem 'newrelic_rpm'    # performance monitoring

# remove when find_by_xx cleaned up
gem 'activerecord-deprecated_finders'

# gems added to Rails.application.config.assets.paths in reverse order (ie last gem has first path)
gem 'coffee-rails'
gem 'uglifier', '>= 1.0.3'

gem 'rails-assets-jquery'
gem 'rails-assets-angular'
gem 'rails-assets-bootstrap-datepicker'
# problem with //= require angular-strap/angular-strap.tpl.min
# config/initializers/angular_strap.rb fixes the problem
# auto includes rails-assets-bootstrap & rails-assets-jquery
# gem 'rails-assets-angular-strap'

# ensure jquery matches jquery_ujs version by include after angular-strap
# required for jquery_ujs and therefore things link link_to_remote
gem 'jquery-rails'

# bootstrap 3 with sass. must be last to allow sass overrides & mixins
gem 'sass'
gem 'sass-rails', '>= 3.2'
gem 'bootstrap-sass', '~> 3.1.1'

# these add generators that help
gem 'haml'

# form creation
gem 'simple_form', '~> 3.1.0.rc1'

# menu highlighting
gem 'tabulous', '~> 2.1.0', github: 'mike-park/tabulous'

# authentication
gem "devise", "~> 3.2.1"
gem 'devise_invitable', '~> 1.3.4'
gem 'pundit', '~> 0.2.2'

# decorating
gem 'draper'

# simple model searching
gem 'ransack'

# vcard export
gem 'vcard'
# country select list
gem 'carmen-rails', '~> 1.0.0'
# pdf export
gem 'prawn'
# map rendering
gem 'gmaps4rails'

# template language for emails
gem 'liquid'

# audit tracking of model changes
gem 'audited', github: 'mike-park/audited', branch: 'rails4'
gem 'audited-activerecord', github: 'mike-park/audited', branch: 'rails4'

# error reporting
gem 'airbrake'

# pagination
gem 'will_paginate-bootstrap'

# access gravatar images
gem 'gravatar-ultimate'

# database
gem 'pg'

# config vars in ENV or application.yml
gem 'figaro', '~> 0.7.0'

# rich texteditor
gem 'ckeditor_rails'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'sqlite3'
  gem 'awesome_print'
  gem 'haml-rails'

  gem 'rspec-rails'
  gem 'factory_girl_rails'

  gem 'selenium-webdriver', '~> 2.41.0'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner', '~> 1.2.0'

  gem 'faker'
end

group :test do
  gem 'email_spec'
  gem 'poltergeist'
  # required only while rubymine defaults to checking 'rspec run under bundler'
  gem 'zeus', '~> 0.13.4.pre2'
end
