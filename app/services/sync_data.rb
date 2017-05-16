module SyncData
  extend self
  BASE_URI = ENV['STAGING_MAIN_SERVER_URL'] || Rails.application.secrets[:env]['MAIN_SERVER_URL']

  def send_request(path, query=nil)
    options = {
      headers: {
        'Content-Type' => 'application/json; charset=UTF-8',
        'Accept' => 'application/json'
      }
    }
    options.merge!(query: query) if query
    HTTParty.post(BASE_URI+path, options)
  end
end
