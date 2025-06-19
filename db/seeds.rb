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
  budget: 3500,
  departure_date: "2024-07-22",
  return_date: "2024-07-26",
  departure_city: "Marseille",
  travellers_type: "Friends"
)

sweden_travel = Travel.create!(
  user_id: user_1.id,
  country: "Sweden",
  number_of_travellers: 2,
  budget: 1200,
  departure_date: "2022-04-01",
  return_date: "2022-04-07",
  departure_city: "Paris",
  travellers_type: "Couple"
)

indonesia_travel = Travel.create!(
  user_id: user_1.id,
  country: "Indonesia",
  number_of_travellers: 2,
  budget: 5000,
  departure_date: "2020-12-12",
  return_date: "2020-12-22",
  departure_city: "Marseille",
  travellers_type: "Couple"
)

mexico_travel = Travel.create!(
  user_id: user_1.id,
  country: "Mexico",
  number_of_travellers: 6,
  budget: 7000,
  departure_date: "2018-07-22",
  return_date: "2018-07-30",
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

gandia = Stop.create!(
  city: "Gandia",
  travel_id: spain_travel.id,
)

malmo = Stop.create!(
  city: "Malmo",
  travel_id: sweden_travel.id,
)

helsingborg = Stop.create!(
  city: "Helsingborg",
  travel_id: sweden_travel.id,
)

halmstad = Stop.create!(
  city: "Halmstad",
  travel_id: sweden_travel.id,
)

bali = Stop.create!(
  city: "Bali",
  travel_id: indonesia_travel.id,
)

surabaya = Stop.create!(
  city: "Surabaya",
  travel_id: indonesia_travel.id,
)

bandung = Stop.create!(
  city: "Bandung",
  travel_id: indonesia_travel.id,
)

jakarta = Stop.create!(
  city: "Jakarta",
  travel_id: indonesia_travel.id,
)

mexico = Stop.create!(
  city: "Mexico",
  travel_id: mexico_travel.id,
)

tabasco = Stop.create!(
  city: "Tabasco",
  travel_id: mexico_travel.id,
)

tulum = Stop.create!(
  city: "Tulum",
  travel_id: mexico_travel.id,
)

cancun = Stop.create!(
  city: "Cancun",
  travel_id: mexico_travel.id,
)

# 3. Display a message 🎉
puts "Finished! Created #{Stop.count} stops."

#---------NOTES ET PICTURES----------

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

Spending.create!([
  { amount_in_eur_cents: 689, amount_cents: 689, category: "accommodation", stop_id: barcelona.id },
  { amount_in_eur_cents: 205.22, amount_cents: 205.22, category: "food",         stop_id: barcelona.id },
  { amount_in_eur_cents: 318.40, amount_cents: 318.40, category: "leisure",      stop_id: barcelona.id },
  { amount_in_eur_cents: 262, amount_cents: 262, category: "transport",    stop_id: barcelona.id }
])

barcelona_picture = Picture.create!(
  stop: barcelona,
  description: "The iconic Arc de Triomf in Barcelona"
)

barcelona_picture.photos.attach(
  io: URI.open("https://plus.unsplash.com/premium_photo-1697729758146-9aa25d423094?q=80&w=768&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "barcelona.jpg"
)

barcelona_picture = Picture.create!(
  stop: barcelona,
  description: "Beaches"
)

barcelona_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1534001265532-393289eb8ed3?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "barcelona.jpg"
)

barcelona_picture = Picture.create!(
  stop: barcelona,
  description: "Museum"
)

barcelona_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1630219694734-fe47ab76b15e?q=80&w=1952&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "barcelona.jpg"
)
barcelona_picture = Picture.create!(
  stop: barcelona,
  description: "Beautiful view !"
)

barcelona_picture.photos.attach(
  io: URI.open("https://plus.unsplash.com/premium_photo-1697730076411-2b4602bf494f?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "barcelona.jpg"
)

Spending.create!([
  { amount_in_eur_cents: 690.50, amount_cents: 690.50, category: "accommodation", stop_id: valencia.id },
  { amount_in_eur_cents: 231.15, amount_cents: 231.15, category: "food",         stop_id: valencia.id },
  { amount_in_eur_cents: 122, amount_cents: 122, category: "leisure",      stop_id: valencia.id },
  { amount_in_eur_cents: 301, amount_cents: 301, category: "transport",    stop_id: valencia.id }
])

Note.create!(
  content: "Relaxing city",
  stop_id: valencia.id,
)

valencia_picture = Picture.create!(
  stop: valencia,
  description: "family walk"
)

valencia_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1736685103486-0e70de4963ca?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "valencia.jpg"
)

valencia_picture = Picture.create!(
  stop: valencia,
  description: "Love garden!"
)

valencia_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1736685103910-dafe7a52cb6c?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "valencia.jpg"
)

valencia_picture = Picture.create!(
  stop: valencia,
  description: "Walking"
)

valencia_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1736685102549-9f184ec1735d?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "valencia.jpg"
)

valencia_picture = Picture.create!(
  stop: valencia,
  description: "Beautiful city !"
)

valencia_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1736685102610-bd8cbd187b7d?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "valencia.jpg"
)

Note.create!(
  content: "Great seafood and beaches.",
  stop_id: gandia.id,
)

gandia_picture = Picture.create!(
  stop: gandia,
  description: "Gandia beach"
)

gandia_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1646586689626-9708c9643da1?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "gandia.jpg"
)

Note.create!(
  content: "Love Malmo!",
  stop_id: malmo.id,
)

malmo_picture = Picture.create!(
  stop: malmo,
  description: "I love the architecture"
)

malmo_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1556802142-ad181001e013?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bWFsbW98ZW58MHx8MHx8fDA%3D"),
  filename: "malmo.jpg"
)

malmo_picture.photos.attach(
  io: URI.open("https://plus.unsplash.com/premium_photo-1671718606047-e150cc8c232f?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "malmo.jpg"
)

malmo_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1540931532254-f03a93675e8a?q=80&w=765&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "malmo.jpg"
)

Note.create!(
  content: "Tried some local dishes",
  stop_id: helsingborg.id,
)

helsingborg_picture = Picture.create!(
  stop: helsingborg,
  description: "Helsingborg is a picturesque coastal city"
)

helsingborg_picture.photos.attach(
  io: URI.open("https://plus.unsplash.com/premium_photo-1732532199606-2308ad7d573c?q=80&w=1166&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "helsingborg.jpg"
)

Note.create!(
  content: "Beautiful city !",
  stop_id: halmstad.id,
)

halmstad_picture = Picture.create!(
  stop: halmstad,
  description: "Halmstad covered in snow creates a serene and magical atmosphere, perfect for enjoying quiet winter days and crisp fresh air."
)

halmstad_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1639588651502-a682abf8ab2d?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "halmstad.jpg"
)

Note.create!(
  content: "Explored jungle",
  stop_id: bali.id,
)

bali_picture = Picture.create!(
  stop: bali,
  description: "Bali, a tropical paradise"
)

bali_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "bali.jpg"
)

bali_picture = Picture.create!(
  stop: bali,
  description: "Bali is a beautiful island"
)

bali_picture.photos.attach(
  io: URI.open("https://images.unsplash.com/photo-1577717903315-1691ae25ab3f?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  filename: "bali.jpg"
)

Note.create!(
  content: "Great street food",
  stop_id: surabaya.id
)

Note.create!(
  content: "Cool climate in Bandung",
  stop_id: bandung.id
)

Note.create!(
  content: "The old town of Jakarta",
  stop_id: jakarta.id
)

Note.create!(
  content: "Visited the historic center",
  stop_id: mexico.id
)

Note.create!(
  content: "Tried cacao from a local plantation",
  stop_id: tabasco.id
)

Note.create!(
  content: "The beaches in Tulum",
  stop_id: tulum.id
)

Note.create!(
  content: "Took a boat tour to Isla Mujeres",
  stop_id: cancun.id
)


# 3. Display a message 🎉
puts "Finished! Created #{Note.count} notes."
