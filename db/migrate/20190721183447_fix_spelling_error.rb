class FixSpellingError < ActiveRecord::Migration[5.2]
  def change
    change_table :missions do |t|
      t.rename :difficuilty, :difficulty
    end
  end
end
