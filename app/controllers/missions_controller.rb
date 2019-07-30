# frozen_string_literal: true

include ActionView::Helpers::DateHelper
include CyphersHelper
include MissionHelper
include AwsHelper
require 'base64'

$encryptionType = JSON.parse(File.read('./app/assets/json/encTypes.json')).to_a
$encryptionPhrases = JSON.parse(File.read('./app/assets/json/encPhrases.json'))
$photoTypes = JSON.parse(File.read('./app/assets/json/picTypes.json'))

class MissionsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    missions = []
    user.missions.each do |m|
      next if m.status == 'open' || m.status == 'current' || m.status == 'rejected'

      completeTime = time_ago_in_words(m.endTime)
      missionDetails = {
        id: m.id,
        type: m.mType,
        difficulty: m.difficulty,
        completed: completeTime,
        result: m.status.upcase
      }
      missions.push(missionDetails)
    end
    missions.reverse!
    render json: {
      message: missions[0..6]
    }
  end

  def show
    user = User.find(params[:user_id])
    # user accepts a mission
    if params[:id] == 'test'
      render json: {
        msg: CyphersHelper.cypher('number', 'abcd 1234 test')
      }
    end
    if params[:id] == 'accepted'
      mission = user.missions.last
      if mission.status == 'open' || mission.status == 'current'
        mission.startTime = 1.second.ago
        mission.endTime = Time.now + (mission.missionTime * 60)
        mission.status = 'current'
        mission.save!
      end
      message = MissionHelper.acceptMission(mission)
    elsif params[:id] == 'rejected'
      mission = user.missions.last
      MissionHelper.rejectMission(mission)
      message = 'well I dont have time for you either'
    elsif params[:id] == 'failed'
      mission = user.missions.last
      mission.status = 'failed'
      mission.endTime = Time.now
      mission.save!
      message = 'you are not fit to be an agent!'

      # check for missions from front end
    elsif params[:id] == 'current'
      mission = user.missions.last
      if mission.status == 'open'

      elsif MissionHelper.missionExpired(mission)
        redirect_to action: 'new'
        mission = user.missions.last
      end
      message = if mission.status == 'open' # Mission is available...
                  MissionHelper.openMission(mission)
                elsif mission.status == 'current' # Mission is active
                  MissionHelper.currentMission(mission)
                else
                  'no mission'
                end
    end
    render json: {
      message: message,
      experience: user.experience
    }
  end

  skip_before_action :verify_authenticity_token
  def update
    incomingData = params[:message]
    incomingPhoto = params[:photo]
    puts '############'
    puts incomingData
    puts '############'

    user = User.find(params[:user_id])
    if params[:id] == 'verify'
      puts user
      puts '==================='
      mission = user.missions.last
      if mission.status == 'current'
        # Verify mission is complete - send back incorrect on verification fails
        mt = mission.mission_type

        if mt.photo
          mt = Photo.find(mt.type_id)

          # send image to hosting, get url,
          puts '^^^^^^^^^^^^Start image processing^^^^^^^^^^^^^^^^^^'

          image_path = "tmp/my_img#{params[:user_id]}.jpg"
          content_length = incomingPhoto.size
          my_read = incomingPhoto.read(content_length)
          image = open(image_path, 'wb')
          image.write(my_read)
          image.close

          imageUrl = AwsHelper.uploadImage(image_path, params[:user_id])
          mt.image = imageUrl
          puts "User uploaded an image: #{imageUrl}"

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

          i = 0
          while mission.verificationUsers.length < 2
            i += 1
            candidate = verifyCandidates.sample
            if mission.verificationUsers.exclude?(candidate)
              mission.verificationUsers.push(candidate)
            end
            break if i == 20
          end

          if mission.verificationUsers.length > 1
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
          render json: {
            message: 'AWAITING VERIFICATION'
          }

        elsif mt.encryption || mt.decryption
          mt = Cypher.find(mt.type_id)
          incomingData = incomingData.downcase.gsub(/[^a-z0-9\s]/i, '')
          verifySolution = mt.solution.downcase.gsub(/[^a-z0-9\s]/i, '')
          if incomingData == verifySolution
            puts 'Mission: SUCCESS'
            mission.status = 'complete'
            mission.endTime = Time.now
            mission.save!
            user.experience += mission.experience
            user.save!
            render json: {
              message: 'MISSION COMPLETE'
            }
          else
            puts "#{incomingData} does not match \n#{mt.solution}"
            render json: {
              message: 'SUBMISSION INVALID'
            }
          end

        elsif mt.verification
          verification = Verification.find(mt.type_id)
          mission.status = 'complete'
          mission.endTime = Time.now
          user.experience += mission.experience
          user.save!
          mission.save!
          render json: {
            message: 'MISSION COMPLETE'
          }
        end

      else
        redirect_to(action: 'new') && return
      end
    end
  end

  def new
    user = User.find(params[:user_id])
    if user.missions.last.status == 'open' || user.missions.last.status == 'current'
      redirect_to(action: 'show', id: 'accepted') && return
    end
    mission = Mission.new
    mission.user = user
    mission.status = 'open'
    mission.difficulty = generateMissionDifficulty.sample
    mission.mType = generateMissionType(user).sample
    mission.experience = generateExperience(mission).sample
    mission.missionTime = generateMissionTime(mission)
    mt = MissionType.new
    mt[mission.mType] = true
    misType = generateMissionByType(mission.mType, mission.difficulty)

    mission.save!
    mt.mission = mission
    mt.save!
    misType.mission_type = mt
    misType.save!
    mt.type_id = misType.id
    mt.save!

    render json: {
      message: mission,
      type: mt,
      mission: misType
    }
  end

  private

  def generateMissionTime(mission)
    mission.experience * 2.2
  end

  def generateMissionByType(type, difficulty)
    case type
    when 'photo'
      mission = Photo.new
      mission.title = 'TAKE A PHOTO OF'
      mission.description = $photoTypes[difficulty].to_a.sample.downcase
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
      missionChoices.push('decryption')
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
end
