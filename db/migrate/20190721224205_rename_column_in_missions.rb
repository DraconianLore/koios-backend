class RenameColumnInMissions < ActiveRecord::Migration[5.2]
  def change
    change_table :missions do |t|
t.rename :missionType, :type
    end
  end
end
