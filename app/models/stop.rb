class Stop < ApplicationRecord
  belongs_to :travel
  has_many :spendings

  geocoded_by :city
  after_validation :geocode, if: :will_save_change_to_city?
end
