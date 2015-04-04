require 'fog/dropbox'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<DROPBOX_OAUTH2_ACCESS_TOKEN>') { ENV['DROPBOX_OAUTH2_ACCESS_TOKEN'] }
end
