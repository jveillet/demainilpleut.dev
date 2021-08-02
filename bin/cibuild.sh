#!/usr/bin/env bash

# halt script on error
set -e

export NOKOGIRI_USE_SYSTEM_LIBRARIES=true
export LANG=C.UTF-8

# Build for deploy
yarn deploy

# Test the HTML of the site
time BRIDGETOWN_ENV=test bundle exec rake test:proofer
