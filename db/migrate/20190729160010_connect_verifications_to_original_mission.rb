class ConnectVerificationsToOriginalMission < ActiveRecord::Migration[5.2]
  def change
    add_column :verifications, :origin, :integer
  end
end
