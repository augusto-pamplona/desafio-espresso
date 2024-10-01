source "https://rubygems.org"

gem "rails", "~> 7.2.1"
gem "pg", "~> 1.1"

gem "bootsnap", require: false
gem "puma", ">= 5.0"
gem "sidekiq"
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "rspec-rails", "~> 7.0.0"
  gem "rubocop-rails-omakase", require: false
  gem "shoulda-matchers"
end
