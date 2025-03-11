source 'https://rubygems.org'
ruby "3.1.6"

gem "excon"
gem 'figaro' # ENV variables
gem 'haml'
gem "nokogiri"
gem 'pg'
gem "rack"
gem 'rake'
gem 'sinatra'
gem 'sinatra-activerecord'
gem 'thin'

group :test, :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'pry'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'rspec-sinatra'
  gem 'rspec'
  gem 'simplecov', require: false
end
