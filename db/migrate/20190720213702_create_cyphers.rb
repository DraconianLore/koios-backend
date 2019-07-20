class CreateCyphers < ActiveRecord::Migration[5.2]
  def change
    create_table :cyphers do |t|
      t.string :title
      t.text :desctiption
      t.text :message
      t.text :solution
      t.boolean :encrypt
      t.string :encryptionType, array: true
      t.timestamps
    end
  end
end
