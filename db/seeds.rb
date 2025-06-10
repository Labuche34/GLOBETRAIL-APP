# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning database..."
Travel.destroy_all

user_1 = User.create!(email: "test@gmail.com", password: "azerty")

# 2. Create the instances 🏗️
puts "Creating Travel..."
Travel.create!(
  user_id: user_1.id,
  country: "Spain",
  number_of_travellers: 6,
  budget: 1000, trip_duration: 4,
  departure_city: "Marseille",
  travellers_type: "Friends"
)

Travel.create!(
  user_id: user_1.id,
  country: "Sweden",
  number_of_travellers: 2,
  budget: 1200, trip_duration: 7,
  departure_city: "Paris",
  travellers_type: "Couple"
)

Travel.create!(
  user_id: user_1.id,
  country: "Indonesia",
  number_of_travellers: 2,
  budget: 5000, trip_duration: 10,
  departure_city: "Marseille",
  travellers_type: "Couple"
)

Travel.create!(
  user_id: user_1.id,
  country: "Mexico",
  number_of_travellers: 6,
  budget: 7000, trip_duration: 8,
  departure_city: "Bruxelles",
  travellers_type: "Family"
)

# 3. Display a message 🎉
puts "Finished! Created #{Travel.count} travels."
