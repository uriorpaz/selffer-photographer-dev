# Load the Rails application.
require File.expand_path('../application', __FILE__)

#logger
Rails.logger = Le.new(ENV['LOGENTRIES_KEY'])

# Initialize the Rails application.
Rails.application.initialize!
