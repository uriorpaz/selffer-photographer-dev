class PossibleFace < ActiveRecord::Base
  has_and_belongs_to_many :temp_recognitions
end
