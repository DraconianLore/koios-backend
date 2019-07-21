class AddForeignKeysForMissionTypes < ActiveRecord::Migration[5.2]
  def change
    change_table :mission_types do |t|
      t.integer :mission_id
    end
    change_table :photos do |t|
      t.integer :mission_type_id
    end
    change_table :cyphers do |t|
      t.integer :mission_type_id
    end
    change_table :verifications do |t|
      t.integer :mission_type_id
    end
  end
end
