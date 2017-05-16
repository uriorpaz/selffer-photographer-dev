class ErrorLog < ActiveRecord::Base
  belongs_to :upload_log, counter_cache: true
end
