class Travel < ApplicationRecord
  belongs_to :user
  has_many :stops, dependent: :destroy
  has_one_attached :photo

end
