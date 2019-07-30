class AddOriginVerificationMissionCounter < ActiveRecord::Migration[5.2]
  def change
    remove_column :verifications, :verifications
    add_column :missions, :verifications, :integer, :default => 0
  end
end
