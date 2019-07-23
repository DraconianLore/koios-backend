include ActionView::Helpers::DateHelper

$encryptionType = JSON.parse(File.read('./app/assets/json/encTypes.json')).to_a
$encryptionPhrases = JSON.parse(File.read('./app/assets/json/encPhrases.json')).to_a

class MissionsController < ApplicationController
    def index
        user = User.find(params[:user_id])

        missions = []
        user.missions.each do |m|
            if m.status != 'open'
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
        end
        render :json => {
            message: missions
        }
    end

    def show
        # do we want to get only the current or open mission?
        mission = Mission.find(params[:id])
        render :json => {
           message: mission
       }
    end

    def new
        user = User.find(params[:user_id])
        if user.missions.last.status == 'open' || user.missions.last.status == 'current'
           return render :json => {
                message: "Sorry Agent #{user.surname}, you still have an active mission"
            }
        end

        mission = Mission.new
        mission.user = user
        mission.status = 'open'
        mission.difficulty = generateMissionDifficulty.sample
        mission.mType = generateMissionType(user).sample
        mission.experience = generateExperience(mission).sample
        mt = MissionType.new
        mt[mission.mType] = true;
        type = generateMissionByType(mission.mType);
        
        mission.save!
        mt.mission = mission
        mt.save!
        type.mission_type = mt
        type.save!
        mt.type_id = type.id
        mt.save

        render :json => {
            message: mission,
            type: mt,
            mission: type
        }
    end


private

    def generateMissionByType(type)
        case type
        when "photo"
            mission = Photo.new
        when "encryption"
            mission = Cypher.new
            mission.encrypt = true
            mission.encryptionType = $encryptionType.sample
            mission.title = "Encrypt this using #{mission.encryptionType}"
            mission.message = $encryptionPhrases.sample

            # temp hardcoding
            mission.solution = mission.message.reverse

        when "decryption"
            mission = Cypher.new
            mission.encrypt = false
            mission.encryptionType = $encryptionType.sample
            mission.title = "Decrypt this using #{mission.encryptionType}"
            mission.solution = $encryptionPhrases.sample
            
            # temp hardcoding
            mission.message = mission.solution.reverse
        end
        mission
    end

    def generateMissionDifficulty()
        difficulty = []
        difficulty.fill('Easy', difficulty.size, 120)
        difficulty.fill('Medium', difficulty.size, 59)
        difficulty.fill('Hard', difficulty.size, 20)
        difficulty.fill('Mission Impossible', difficulty.size, 1)
        difficulty 
    end

    def generateMissionType(user)
        missionChoices = []
        if user.rank > 0
            missionChoices.push('photo')
        end
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
