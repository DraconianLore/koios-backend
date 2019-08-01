desc "Clear current mission and reset to specific missions for demo"
task :demoSetup => :environment do

    user = User.first
    user.experience = 530
    mission = user.missions.last
    mission.status = 'failed'
    mission.endTime = Time.now
    mission.save!
    
    miss = Mission.new
    miss.user = user
    miss.status = 'open'
    miss.difficulty = 'Medium'
    miss.mType = 'decryption'
    miss.experience = 300
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
    mt.mission = miss
    mt.save!
    misType.mission_type = mt
    misType.save!
    mt.type_id = misType.id
    mt.save!
    puts "User 1 setup complete"

    user = User.second
    user.experience = 333
    mission = user.missions.last
    mission.status = 'failed'
    mission.endTime = Time.now
    mission.save!

    miss = Mission.new
    miss.user = user
    miss.status = 'open'
    miss.difficulty = 'Easy'
    miss.mType = 'encryption'
    miss.experience = 300
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
    mt.mission = miss
    mt.save!
    misType.mission_type = mt
    misType.save!
    mt.type_id = misType.id
    mt.save!
    puts "User 2 setup complete"
    
end