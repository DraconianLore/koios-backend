class FixSpellingErrors < ActiveRecord::Migration[5.2]
  def change
    change_table :cyphers do |t|
t.rename :desctiption, :description
    end
  end
end
