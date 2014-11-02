source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'ejs'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# Authorization (https://github.com/ryanb/cancan)
gem "cancan", "~> 1.6.9"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'



# Deploy with Capistrano (not needed for heroku)
# gem 'capistrano'

group :production do
# Use unicorn as the app server
# remember to bundle install --without production on windows
gem 'unicorn'
end

group :development, :test do
  gem 'sqlite3'
  # To use debugger
  gem 'debugger'
  # debugger is depreciated and should be used only for ruby 1.9
  #gem 'byebug'
  gem 'binding_of_caller'
  gem 'better_errors', '1.1.0'
end

# going to try not using mongoid
gem 'mongoid', '~> 3.0.0'
gem 'andand'

#performance improvements w/BSON
# gem 'bson_ext'