require 'localeapp/rails'

Localeapp.configure do |config|
  config.api_key = '67Bx31aYdVFHo2tAvciKR58EJhPCNJ0mQjDl5KD4NP7VYtDgpR'
  config.polling_environments = []
end

#Pull on heroku dyno restart
Localeapp::CLI::Pull.new.execute #if Rails.env.production?
