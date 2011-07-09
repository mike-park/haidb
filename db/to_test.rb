#!/usr/bin/env ruby
# copy SiteDefault entries to test database

DEVDB = "development.sqlite3"
TESTDB = "test.sqlite3"

tables = %w(site_defaults translation_keys translation_texts)
tables.each {|t| system("sqlite3 #{TESTDB} 'drop table if exists #{t}'") }

tables.each do |t|
  system("echo .dump #{t} | sqlite3 #{DEVDB} | sqlite3 #{TESTDB}")
end
