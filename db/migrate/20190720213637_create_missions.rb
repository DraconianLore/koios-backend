class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.string :status
      t.integer :experience
      t.string :missionType
      t.datetime :startTime
      t.datetime :endTime
      t.string :difficuilty
      t.integer :verificationUsers, array: true, default: []
      t.timestamps
    end
  end
end
