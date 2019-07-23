class TidyUpPhoto < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :photoType
  end
end
