# frozen_string_literal: true

class CreateWaypoints < ActiveRecord::Migration[7.0]
  def change
    create_table :waypoints do |t|
      t.string :name
      t.text :description
      t.float :longitude
      t.float :latitude
      t.integer :stop_min
      t.integer :index
      t.belongs_to :day, null: false, foreign_key: true

      t.timestamps
    end
  end
end
