# frozen_string_literal: true

class CreateTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :trips do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
