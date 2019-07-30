class AddDeviceIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :deviceId, :string
  end
end
