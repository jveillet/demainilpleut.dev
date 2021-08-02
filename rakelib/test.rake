# frozen_string_literal: true

require 'html-proofer' if ENV['BRIDGETOWN_ENV'] == 'test'

namespace :test do
  desc 'Test the website'
  task :proofer do
    options = {
      disable_external: true,
      allow_hash_href: true,
      check_html: true,
      check_img_http: true,
      cache: {
        timeframe: '4w'
      }
    }
    begin
      HTMLProofer.check_directory('./public', options).run
    rescue StandardError => e
      puts e.to_s
    end
  end
end
