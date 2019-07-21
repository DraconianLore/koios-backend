class ChangeMissionTypesToMissionTypes < ActiveRecord::Migration[5.2]
  def change
    rename_table :mission_types, :missionTypes
  end
end
