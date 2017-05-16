 class TempRecognitionPhoto < ActiveRecord::Base
  belongs_to :temp_recognition, counter_cache: :photos_count
  belongs_to :photo
 end