# frozen_string_literal: true

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
      v = Verification.find(mission.mission_type.type_id)
      v.verifications += 1
      end
    puts '###### REJECT #####'
    mission.status = 'rejected'
    mission.endTime = Time.now
    mission.save!
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
    else
      mt = Verification.find(mt.type_id)
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
    puts(mission.status)
    puts('!!!!!!!!', mission.endTime)
    puts('########', Time.now)
    if mission.status == 'current'
      puts(mission.endTime < Time.now)
      if mission.endTime < Time.now
        mission.status = 'failed'
        mission.save!
        true
      end
    end
    false
  end
end
