source 'http://code.stripe.com'
source 'https://rubygems.org'

ruby "2.0.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem "best_in_place", github: 'bernat/best_in_place'


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~>2.2.2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'bootstrap-sass', '~> 3.1.1'
gem "paperclip", "~> 4.1"
gem "paperclip-dropbox", ">= 1.1.7"
gem 'aws-sdk'
gem "figaro", '~>1.0.0.rc1'
gem 'devise', '~>3.2.4'
gem 'stripe', '~>1.14.0'
gem 'jquery-turbolinks'
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap'
gem 'searchkick', '~> 0.8.2'
gem 'delayed_job_active_record', '~> 4.0.2'
gem 'newrelic_rpm', '~> 3.9.5.251'
gem 'asset_sync', '~> 1.1.0'


platforms :ruby do # linux
  gem 'unicorn', '~> 4.8.3'
  gem 'rack-timeout', '~> 0.1.0'
end

group :production do
	gem 'pg'
	gem 'rails_12factor'
    gem 'workless', '~> 1.2.3'
end

group :development, :test do
	gem 'sqlite3'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
