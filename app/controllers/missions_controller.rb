include ActionView::Helpers::DateHelper


class MissionsController < ApplicationController
    def index
        user = User.find(params[:user_id])

        missions = []
        user.missions.each do |m|
            if m.status != 'open'
                completeTime = time_ago_in_words(m.endTime)
                missionDetails = "Type: #{m.type} - Difficulty: #{m.difficulty} - Completed: #{completeTime} ago - Result: #{m.status.upcase}"
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
        mission.type = generateMissionType(user).sample
        mission.experience = generateExperience(mission).sample

        render :json => {
            message: mission
        }
    end


private

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
