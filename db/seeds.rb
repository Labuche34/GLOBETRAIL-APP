# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

#---------TRAVELS----------

puts "Cleaning database..."
Travel.destroy_all
User.destroy_all

user_1 = User.create!(email: "test@gmail.com", password: "azerty")

# 2. Create the instances 🏗️
puts "Creating Travel..."
spain_travel = Travel.create!(
  user_id: user_1.id,
  country: "Spain",
  number_of_travellers: 6,
  budget: 1000,
  departure_date: "2025-07-22",
  return_date: "2025-07-26",
  departure_city: "Marseille",
  travellers_type: "Friends"
)

sweden_travel = Travel.create!(
  user_id: user_1.id,
  country: "Sweden",
  number_of_travellers: 2,
  budget: 1200,
  departure_date: "2018-07-22",
  return_date: "2018-07-22",
  departure_city: "Paris",
  travellers_type: "Couple"
)

indonesia_travel = Travel.create!(
  user_id: user_1.id,
  country: "Indonesia",
  number_of_travellers: 2,
  budget: 5000,
  departure_date: "2018-07-22",
  return_date: "2018-07-22",
  departure_city: "Marseille",
  travellers_type: "Couple"
)

mexico_travel = Travel.create!(
  user_id: user_1.id,
  country: "Mexico",
  number_of_travellers: 6,
  budget: 7000,
  departure_date: "2018-07-22",
  return_date: "2018-07-22",
  departure_city: "Bruxelles",
  travellers_type: "Family"
)

# 3. Display a message 🎉
puts "Finished! Created #{Travel.count} travels."

#---------STOPS----------

# 1. Clean the database 🗑️
puts "Cleaning stops database..."
Stop.destroy_all

# 2. Create the instances 🏗️
puts "Creating stops..."
barcelona = Stop.create!(
  city: "Barcelona",
  travel_id: spain_travel.id,
)

valencia = Stop.create!(
  city: "Valencia",
  travel_id: spain_travel.id,
)

# 3. Display a message 🎉
puts "Finished! Created #{Stop.count} stops."

#---------NOTES----------

# 1. Clean the database 🗑️
puts "Cleaning notes database..."
Note.destroy_all

# 2. Create the instances 🏗️
puts "Creating stops..."
Note.create!(
  content: "Plenty of monuments to visit",
  stop_id: barcelona.id,
)

Note.create!(
  content: "Great city",
  stop_id: barcelona.id,
)

Note.create!(
  content: "Relaxing city",
  stop_id: valencia.id,
)

# 3. Display a message 🎉
puts "Finished! Created #{Note.count} notes."
