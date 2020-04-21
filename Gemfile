source 'https://rubygems.org'
ruby "2.4.5"

gem "excon", ">= 0.71.0"
gem 'figaro' # ENV variables
gem 'haml'
gem "nokogiri", ">= 1.10.8"
gem 'pg'
gem "rack", ">= 2.0.8"
gem 'rake'
gem 'sinatra'
gem 'sinatra-activerecord'
# Activesupport is a dependency of sinatra-activerecord,
# it is pinned to maintain support for Rubies before 2.5.
# You can safely remove the requirement from the Gemfile
# if the version pin is not necessary.
gem 'activesupport', '~> 5.0'

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
