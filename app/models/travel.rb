require 'open-uri'

class Travel < ApplicationRecord
  belongs_to :user
  has_many :stops, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_one_attached :photo
  after_create_commit :attach_image_to_place

  geocoded_by :country
  after_validation :geocode, if: :will_save_change_to_country?

  def attach_image_to_place
    country_name = self.country
    image_url = fetch_image_url

    return unless image_url

    file = OpenURI.open_uri(image_url)

    # Purge l'ancienne image si besoin
    self.photo.purge if self.photo.attached?

    self.photo.attach(
      io: file,
      filename: "#{country_name.parameterize}.jpg",
      content_type: "image/jpeg"
    )
  end

  def fetch_image_url
    uri = URI("https://api.unsplash.com/search/photos?query=#{CGI.escape(self.country)}&client_id=#{ENV['UNSPLASH_ACCESS_KEY']}")

    response = Net::HTTP.get_response(uri)
    data = JSON.parse(response.body)

    if response.is_a?(Net::HTTPSuccess) && data["results"].any?
      data["results"].first["urls"]["regular"]
    else
      nil
    end
  end
end
