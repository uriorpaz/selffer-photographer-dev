 class RecognitionPhoto < ActiveRecord::Base
  belongs_to :recognition
  belongs_to :photo
 end