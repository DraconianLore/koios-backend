class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.string :title
      t.text :description
      t.string :photoType, array: true
      t.binary :image
      t.timestamps
    end
  end
end
