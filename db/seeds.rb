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
user.experience = 555
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

# user 1 seed for demo
miss = Mission.new
miss.user = user
miss.status = 'open'
miss.difficulty = 'Medium'
miss.mType = 'decryption'
miss.experience = 600
miss.missionTime = 32
mt = MissionType.new
mt.decryption = true,
misType = Cypher.new
misType.encrypt = false
misType.encryptionType = "letterShift7"
misType.title = 'Decrypt this message'
misType.solution = "how often have i said that when you have excluded the impossible whatever remains however improbable must be the truth"
misType.message = "ovd vmalu ohcl p zhpk aoha dolu fvb ohcl lejsbklk aol ptwvzzpisl dohalcly ylthpuz ovdlcly ptwyvihisl tbza il aol aybao"
misType.description = "That would be too easy wouldn't it"
miss.save!
mt.mission = missmt.save!
misType.mission_type = mt
misType.save!
mt.type_id = misType.id
mt.save!
# end demo seed

user = User.new
user.surname = 'Bond'
user.firstName = 'Mister'
user.email = 'shaken@olive.martini'
user.password = 'bond'
user.rank = 3
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

# user 2 seed for demo
miss = Mission.new
miss.user = user
miss.status = 'open'
miss.difficulty = 'Easy'
miss.mType = 'encryption'
miss.experience = 600
miss.missionTime = 32
mt = MissionType.new
mt.encryption = true,
misType = Cypher.new
misType.encrypt = true
misType.encryptionType = 'reverse'
misType.title = 'Encrypt this using a reverse cypher'
misType.solution = "sbal esuohthgil ot emoclew"
misType.message =  "Welcome to Lighthouse Labs"
misType.description = "Write the message in reverse \nFor example: 'the cat' becomes 'tac eht'"
miss.save!
mt.mission = missmt.save!
misType.mission_type = mt
misType.save!
mt.type_id = misType.id
mt.save!
# end demo seed

user = User.new
user.surname = 'Potatohead'
user.firstName = 'Mister'
user.email = 'potato@parts.hasbro'
user.password = 'potatohead'
user.rank = 1
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
