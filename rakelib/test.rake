# frozen_string_literal: true

require 'html-proofer' if ENV['BRIDGETOWN_ENV'].to_s == 'test'

namespace :proofer do
  desc 'Test the website'
  task :test do
    options = {
      disable_external: true,
      allow_hash_href: true,
      check_html: true,
      check_img_http: true,
      ignore_urls: [/example.com/, /localhost/],
      cache: {
        timeframe: { internal: '2w', external: '4w' }
      }
    }
    begin
      HTMLProofer.check_directory('./public', options).run
    rescue StandardError => e
      puts 'Error while checking with HTMLProofer'
      puts e.message
      puts e.backtrace.join("\n")
    end
  end
end
