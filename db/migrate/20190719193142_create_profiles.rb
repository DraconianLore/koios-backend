class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.integer :experience
      t.integer :rank
      t.boolean :warning
      t.timestamps
    end
  end
end
