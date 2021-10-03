class CreateDays < ActiveRecord::Migration[7.0]
  def change
    create_table :days do |t|
      t.string :name
      t.text :description
      t.integer :start_waypoint_id
      t.integer :end_waypoint_id
      t.datetime :start_at
      t.belongs_to :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
