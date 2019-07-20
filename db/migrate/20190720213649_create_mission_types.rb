class CreateMissionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :mission_types do |t|
      t.integer :type_id
      t.boolean :photo
      t.boolean :verification
      t.boolean :encryption
      t.boolean :decryption
      t.timestamps
    end
  end
end
