class FixTypeInCypher < ActiveRecord::Migration[5.2]
  def change
    remove_column :cyphers, :encryptionType
    change_table :cyphers do |t|
      t.string :encryptionType
    end
  end
end
