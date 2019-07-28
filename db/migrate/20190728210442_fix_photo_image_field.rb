class FixPhotoImageField < ActiveRecord::Migration[5.2]
  def change
    remove_column :verifications, :image
    change_table :verifications do |t|
      t.string :image
    end
  end
end
