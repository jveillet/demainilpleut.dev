# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

# Hello! This is where you manage which Bridgetown version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Bridgetown with `bundle exec`, like so:
#
#   bundle exec bridgetown serve
#
# This will help ensure the proper Bridgetown version is running.
#
# To install a plugin, simply run bundle add and specify the group
# "bridgetown_plugins". For example:
#
#   bundle add some-new-plugin -g bridgetown_plugins
#
# Happy Bridgetowning!

gem "bridgetown", "~> 0.21.5"

# Rake is a Make-like program implemented in Ruby.
gem 'rake', '~> 13.0.3'

group :bridgetown_plugins do
  # A Bridgetown plugin to generate an Atom feed of your Bridgetown posts
  gem 'bridgetown-feed', '~> 2.0', '>= 2.0.1'
end

group :development, :test do
  # Test your rendered HTML files to make sure they're accurate.
  gem 'html-proofer', '~> 4.1'
end
