#!/usr/bin/env bash

# halt script on error
set -e

export NOKOGIRI_USE_SYSTEM_LIBRARIES=true
export LANG=C.UTF-8

# Build for deploy
bundle exec rake deploy

# Test the HTML of the site
time BRIDGETOWN_ENV=test bundle exec rake proofer:test
