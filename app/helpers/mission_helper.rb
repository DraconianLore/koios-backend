# frozen_string_literal: true

include ActionView::Helpers::DateHelper
include CyphersHelper

$encryptionType = JSON.parse(File.read('./app/assets/json/encTypes.json')).to_a
$encryptionPhrases = JSON.parse(File.read('./app/assets/json/encPhrases.json'))
$photoTypes = JSON.parse(File.read('./app/assets/json/picTypes.json'))
$selfieTypes = JSON.parse(File.read('./app/assets/json/selfieTypes.json'))


module MissionHelper
  def acceptMission(mission)
    message = {
      id: mission.id,
      start: mission.startTime,
      end: mission.endTime
    }
    mt = mission.mission_type
    if mt.photo
      mt = Photo.find(mt.type_id)
    elsif mt.encryption || mt.decryption
      mt = Cypher.find(mt.type_id)
      message[:message] = mt.message
    else
      mt = Verification.find(mt.type_id)
      end
    message[:description] = mt.description
    message[:title] = mt.title
    message
  end

  def rejectMission(mission)
    if mission.mType == 'verification'
      # TODO: - add logic to verify original mission
      verification = Verification.find(mt.type_id)
      verificationOrigin = Mission.find(verification.origin)
      verificationOrigin.verifications += 1
      if verificationOrigin.verifications >= verificationOrigin.verificationUsers.length
        verificationOrigin.endTime = Time.now
        verificationOrigin.status = 'complete'
      end
      verificationOrigin.save!
      mission.status = 'rejected'
      mission.endTime = Time.now
      mission.save!

      end
    mission.status = 'rejected'
    mission.endTime = Time.now
    mission.save!
  end

  def verifyCypher(answer, solution)
    answer = answer.downcase.gsub(/[^a-z]/, '')
    solution = solution.downcase.gsub(/[^a-z]/, '')
    # strip all punctuation and spaces and compare raw strings
    answer == solution
  end

  def currentMission(mission)
    mEndTime = mission.endTime.to_f * 1000
    message = {
      current: true,
      endTime: mEndTime,
      mType: mission.mType,
      missionId: mission.id
    }
    mt = mission.mission_type
    if mt.photo
      mt = Photo.find(mt.type_id)
      message[:message] = mt.description
    elsif mt.encryption || mt.decryption
      mt = Cypher.find(mt.type_id)
      message[:message] = mt.message
      message[:description] = mt.description
      puts "SOLUTION - for demo purposes /////// #{mt.solution.upcase} ////////"
    else
      mt = Verification.find(mt.type_id)
      message[:message] = mt.description
      message[:image] = mt.image
    end
    message[:description] = mt.description
    message[:title] = mt.title
    message
    end

  def openMission(mission)
    message = {
      available: true,
      mTime: mission.missionTime,
      mType: mission.mType,
      mDifficulty: mission.difficulty
    }
    message
  end

  def missionExpired(mission)
    if mission.status == 'current'
      if mission.endTime < Time.now
        mission.status = 'failed'
        mission.save!
        true
      end
    end
    false
  end

  def makeVerificationMissions(mission, mt, user, imageUrl)
    verifyCandidates = []
    users = User.all
    users.each do |u|
      if u.missions.length >= 1
        userMission = u.missions.last
        if userMission.status != 'open' && userMission.status != 'current'
          verifyCandidates.push(u) if u != user
        end
      else
        verifyCandidates.push(u)
      end
    end
    if verifyCandidates.length >= 2
      # create verification missions if there are enough agents without missions
      while mission.verificationUsers.length <= 2
        candidate = verifyCandidates.sample
        unless mission.verificationUsers.include? candidate
          mission.verificationUsers.push(candidate)
        end
      end
      mission.verificationUsers.each do |u|
        verifyMission = Mission.new
        verifyMission.user = u
        verifyMission.status = 'open'
        verifyMission.difficulty = 'Easy'
        verifyMission.mType = 'verification'
        verifyMission.experience = 5
        verifyMission.missionTime = 5
        vmt = MissionType.new
        vmt[verifyMission.mType] = true
        vMisType = Verification.new
        vMisType.origin = mission.id
        vMisType.title = 'Does this picture contain'
        vMisType.description = mt.description
        vMisType.image = imageUrl
        verifyMission.save!
        vmt.mission = verifyMission
        vmt.save!
        vMisType.mission_type = vmt
        vMisType.save!
        vmt.type_id = vMisType.id
        vmt.save!
      end
    end
    mission.status = 'awaiting verification'
    mission.save!
  end

  # Mission Generation Helpers
  def generateMissionTime(mission)
    mission.experience * 2.2
  end

  def generateMissionDifficulty
    difficulty = []
    difficulty.fill('Easy', difficulty.size, 120)
    difficulty.fill('Medium', difficulty.size, 59)
    difficulty.fill('Hard', difficulty.size, 20)
    difficulty.fill('Mission Impossible', difficulty.size, 1)
    difficulty
  end

  def generateMissionType(user)
    missionChoices = []
    missionChoices.push('photo') if user.rank > 0
    if user.rank > 1
      missionChoices.push('encryption')
      missionChoices.push('decryption') if user.experience > 500
    end
    missionChoices
  end

  def generateExperience(mission)
    if mission.difficulty == 'Easy'
      exp = 8..14
    elsif mission.difficulty == 'Medium'
      exp = 15..24
    elsif mission.difficulty == 'Hard'
      exp = 24..39
    elsif mission.difficulty == 'Mission Impossible'
      exp = 40..80
    end
    exp.to_a
  end

  def generateMissionByType(type, difficulty)
    case type
    when 'photo'
      mission = Photo.new
      mission.title = ['TAKE A PHOTO OF','TAKE A SELFIE WITH'].sample
      if mission.title == 'TAKE A PHOTO OF'
        mission.description = "#{$photoTypes[difficulty].to_a.sample}\n(Don't forget to ask for permission)"
      else
        mission.description = $selfieTypes[difficulty].to_a.sample
      end
    when 'encryption'
      mission = Cypher.new
      mission.encrypt = true
      mission.encryptionType = $encryptionType.sample
      mission.title = "Encrypt this using a #{mission.encryptionType} cypher"
      mission.message = $encryptionPhrases[difficulty].to_a.sample.downcase
      mission.solution = CyphersHelper.cypher(mission.encryptionType, mission.message)
      mission.description = CyphersHelper.instructions(mission.encryptionType)

    when 'decryption'
      mission = Cypher.new
      mission.encrypt = false
      mission.encryptionType = $encryptionType.sample
      mission.title = 'Decrypt this message'
      mission.solution = $encryptionPhrases[difficulty].to_a.sample.downcase
      mission.message = CyphersHelper.cypher(mission.encryptionType, mission.solution)
      mission.description = "That would be too easy wouldn't it"
    end
    mission
  end
end
