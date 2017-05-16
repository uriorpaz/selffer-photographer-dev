CarrierWave.configure do |config|
  config.aws_credentials = {
    # Configuration for Amazon S3 should be made available through an Environment variable.
    # For local installations, export the env variable through the shell OR
    # if using Passenger, set an Apache environment variable.
    #
    # In Heroku, follow http://devcenter.heroku.com/articles/config-vars
    #
    # $ heroku config:add S3_KEY=your_s3_access_key S3_SECRET=your_s3_secret S3_REGION=eu-west-1 S3_ASSET_URL=http://assets.example.com/ S3_BUCKET_NAME=s3_bucket/folder
 
    # Configuration for Amazon S3
    access_key_id:       Rails.application.secrets[:env]['S3_KEY'],
    secret_access_key:   Rails.application.secrets[:env]['S3_SECRET'],
    region:              Rails.application.secrets[:env]['S3_REGION']
  }

  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => Rails.application.secrets[:env]['S3_KEY'],       # required
    :aws_secret_access_key  => Rails.application.secrets[:env]['S3_SECRET'],       # required
    :region                 => Rails.application.secrets[:env]['S3_REGION']  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'selffer'

  # For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :aws
  end
 
  config.cache_dir = "#{Rails.root}/tmp/uploads"                  # To let CarrierWave work on heroku 
  config.aws_bucket    = Rails.application.secrets[:env]['S3_BUCKET_NAME']
  config.aws_acl    = 'public-read'

  puts "Fog config: #{config.fog_credentials.inspect}, #{config.fog_directory}"

  # config.s3_access_policy = :public_read                          # Generate http:// urls. Defaults to :authenticated_read (https://)
  # config.fog_host         = "#{ENV['S3_ASSET_URL']}/#{ENV['S3_BUCKET_NAME']}"
end