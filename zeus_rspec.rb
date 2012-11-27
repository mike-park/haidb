#!/usr/bin/env ruby
ARGV.unshift 'rspec'
require 'rubygems'
gem 'zeus'
load Gem.bin_path('zeus', 'zeus')
