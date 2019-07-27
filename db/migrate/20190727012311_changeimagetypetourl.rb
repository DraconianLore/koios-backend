# frozen_string_literal: true

class Changeimagetypetourl < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :image
    change_table :photos do |t|
      t.string :image
    end
  end
end
