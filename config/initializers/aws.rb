Aws.config.update({
  region:  Rails.application.secrets[:env]['S3_REGION'],
  credentials: Aws::Credentials.new(Rails.application.secrets[:env]['S3_KEY'], Rails.application.secrets[:env]['S3_SECRET']),
})

S3_BUCKET = Aws::S3::Resource.new.bucket(Rails.application.secrets[:env]['S3_BUCKET_NAME'])