class CreateVerifications < ActiveRecord::Migration[5.2]
  def change
    create_table :verifications do |t|
      t.binary :image
      t.string :title
      t.string :description
      t.integer :verifications
      t.timestamps
    end
  end
end
