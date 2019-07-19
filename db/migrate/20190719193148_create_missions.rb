class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.string :type
      t.text :description
      t.integer :experience
      t.boolean :current
      t.boolean :complete
      t.datetime :startTime
      t.datetime :endTime
      t.timestamps
    end
  end
end
