class AddMissionTimeToMissions < ActiveRecord::Migration[5.2]
  def change
    change_table :missions do |t|
      t.integer :missionTime
    end
  end
end
