# frozen_string_literal: true

# Migration to create the days table
class CreateDays < ActiveRecord::Migration[7.0]
  def change
    create_table :days do |t|
      t.string :name
      t.text :description
      t.datetime :start_at
      t.belongs_to :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
