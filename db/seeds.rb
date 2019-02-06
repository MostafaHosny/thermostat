# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do
  location = Location.create(lat: "2.3", lng: "1.2")

  thermo = Thermostat.create(location: location)
  p "Created thermostat with household_token: #{thermo.household_token}"
end
