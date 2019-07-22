class ChangeFromTypeReserverWordTomType < ActiveRecord::Migration[5.2]
  def change
    change_table :missions do |t|
      t.rename :type, :mType
    end
    end
end
