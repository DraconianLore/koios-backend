class FixMissiontypes < ActiveRecord::Migration[5.2]
  def change
    if table_exists?("missionTypes")
      rename_table :missionTypes, :mission_types
    end
  end
end
