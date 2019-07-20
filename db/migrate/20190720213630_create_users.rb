class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :surname
      t.string :firstName
      t.string :email
      t.string :password
      t.integer :currentMission
      t.integer :completedMissions, array: true, default: []
      t.integer :experience
      t.integer :rank
      t.timestamps
    end
  end
end
