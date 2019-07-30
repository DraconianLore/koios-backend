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

    user = User.find(params[:user_id])
    if params[:id] == 'verify'
      mission = user.missions.last
      if mission.status == 'current'
        mt = mission.mission_type

        if mt.photo
          mt = Photo.find(mt.type_id)
          image_path = "tmp/my_img#{params[:user_id]}.jpg"
          content_length = incomingPhoto.size
          my_read = incomingPhoto.read(content_length)
          image = open(image_path, 'wb')
          image.write(my_read)
          image.close

          imageUrl = AwsHelper.uploadImage(image_path, params[:user_id])
          mt.image = imageUrl
          puts "User #{user} uploaded an image: #{imageUrl}"
          MissionHelper.makeVerificationMissions(mission, mt, user, imageUrl)
          render json: {
            message: 'AWAITING VERIFICATION'
          }

        elsif mt.encryption || mt.decryption
          mt = Cypher.find(mt.type_id)

          if MissionHelper.verifyCypher(incomingData, mt.solution)
            mission.status = 'complete'
            mission.endTime = Time.now
            mission.save!
            user.experience += mission.experience
            user.save!
            render json: {
              message: 'MISSION COMPLETE'
            }
          else
            puts "Cypher verification:\n#{incomingData} does not match \n#{mt.solution}"
            render json: {
              message: 'INVALID SUBMISSION'
            }
          end

        elsif mt.verification
          verification = Verification.find(mt.type_id)
          verificationOrigin = Mission.find(verification.origin)
          verificationOrigin.verifications += 1
          if verificationOrigin.verifications >= verificationOrigin.verificationUsers.length
            verificationOrigin.endTime = Time.now
            verificationOrigin.status = 'complete'
          end
          verificationOrigin.save!

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
    mission.difficulty = MissionHelper.generateMissionDifficulty.sample
    mission.mType = MissionHelper.generateMissionType(user).sample
    mission.experience = (MissionHelper.generateExperience(mission).sample / user.rank).ceil
    mission.missionTime = MissionHelper.generateMissionTime(mission)
    mt = MissionType.new
    mt[mission.mType] = true
    misType = MissionHelper.generateMissionByType(mission.mType, mission.difficulty)

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
end
