module ApiUrlHelper
  def self.api_url(path=nil)
    "#{ENV['API_URL'] || Rails.application.secrets[:env]['API_URL']}#{path}"
  end
  def self.api_url_eb(path=nil)
    "#{ENV['API_URL_EB'] || Rails.application.secrets[:env]['API_URL_EB']}#{path}"
  end
end