# frozen_string_literal: true

class AddUserToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :username, :string
    add_index :trips, :username
  end
end
