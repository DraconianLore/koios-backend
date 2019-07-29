# frozen_string_literal: true

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
user.experience = 482
user.save!

miss = Mission.new
miss.status = 'complete'
miss.experience = 10
miss.mType = 'photo'
miss.startTime = 1.day.ago
miss.endTime = 18.hours.ago
miss.difficulty = 'Tutorial'
miss.user = user
miss.save!


user = User.new
user.surname = 'Bond'
user.firstName = 'Mister'
user.email = 'shaken@olive.martini'
user.password = 'bond'
user.rank = 2
user.experience = 20
user.save!

miss = Mission.new
miss.status = 'complete'
miss.experience = 10
miss.mType = 'photo'
miss.startTime = 1.day.ago
miss.endTime = 18.hours.ago
miss.difficulty = 'Tutorial'
miss.user = user
miss.save!

user = User.new
user.surname = 'Potatohead'
user.firstName = 'Mister'
user.email = 'potato@parts.hasbro'
user.password = 'potatohead'
user.rank = 2
user.experience = 20
user.save!

miss = Mission.new
miss.status = 'complete'
miss.experience = 10
miss.mType = 'photo'
miss.startTime = 1.day.ago
miss.endTime = 18.hours.ago
miss.difficulty = 'Tutorial'
miss.user = user
miss.save!

user = User.new
user.surname = 'Rogers'
user.firstName = 'Mister'
user.email = 'beautiful@day.friend'
user.password = 'rogers'
user.rank = 2
user.experience = 20
user.save!

miss = Mission.new
miss.status = 'complete'
miss.experience = 10
miss.mType = 'photo'
miss.startTime = 1.day.ago
miss.endTime = 18.hours.ago
miss.difficulty = 'Tutorial'
miss.user = user
miss.save!

user = User.new
user.surname = 'Potatohead'
user.firstName = 'Misses'
user.email = 'girl@potato.hasbro'
user.password = 'spud'
user.rank = 2
user.experience = 20
user.save!

miss = Mission.new
miss.status = 'complete'
miss.experience = 10
miss.mType = 'photo'
miss.startTime = 1.day.ago
miss.endTime = 18.hours.ago
miss.difficulty = 'Tutorial'
miss.user = user
miss.save!

user = User.new
user.surname = 'E'
user.firstName = 'Mister'
user.email = 'riddle@enigma.codex'
user.password = 'EEEE'
user.rank = 2
user.experience = 20
user.save!

miss = Mission.new
miss.status = 'complete'
miss.experience = 10
miss.mType = 'photo'
miss.startTime = 1.day.ago
miss.endTime = 18.hours.ago
miss.difficulty = 'Tutorial'
miss.user = user
miss.save!

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
