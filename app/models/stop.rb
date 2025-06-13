class Stop < ApplicationRecord
  belongs_to :travel
  has_many :spendings, dependent: :destroy
  has_many :pictures, dependent: :destroy

  has_many :notes, dependent: :destroy

  geocoded_by :city
  after_validation :geocode, if: :will_save_change_to_city?
end
