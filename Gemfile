source 'http://rubygems.org'

gem 'figaro' # ENV variables
gem 'rake'
gem 'sinatra'
gem 'sinatra-activerecord'

group :production, :development do
  gem 'pg'
end

group :test do
  gem 'capybara'
  gem 'rspec-sinatra'
  gem 'rspec'
  gem 'sqlite3'
end
