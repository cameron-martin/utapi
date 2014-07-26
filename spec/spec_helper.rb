require 'rubygems'
require 'bundler/setup'

require 'vcr'
require 'dotenv'

Dotenv.load

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

#require 'net-http-spy'
#
#Net::HTTP.http_logger = Logger.new(File.expand_path("../tmp/logs/login-#{Time.now}.log", File.dirname(__FILE__)))
#Net::HTTP.http_logger_options = { verbose: true }