class Stop < ApplicationRecord
  belongs_to :travel
  has_many :spendings
end
