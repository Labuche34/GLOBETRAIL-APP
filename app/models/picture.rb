class Picture < ApplicationRecord
  belongs_to :stop
  has_many_attached :photos
end
