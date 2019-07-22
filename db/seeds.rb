# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Users
user = User.new
user.surname = 'Smith'
user.firstName = 'Mister'
user.email = 'smith@agents.matrix'
user.password = 'smith'
user.rank = 2
user.experience = 20
user.save!

# Missions
miss = Mission.new
miss.status = 'complete'
miss.experience = 10
miss.mType = 'photo'
miss.startTime = 1.day.ago
miss.endTime = 18.hours.ago
miss.difficulty = 'Easy'
miss.user = User.first
miss.save!

miss = Mission.new
miss.status = 'failed'
miss.experience = 10
miss.mType = 'photo'
miss.startTime = 12.hours.ago
miss.endTime = 11.hours.ago
miss.difficulty = 'Easy'
miss.user = User.first
miss.save!

puts '##### Seeding complete #####'