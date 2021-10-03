# frozen_string_literal: true

class Waypoint < ApplicationRecord
  belongs_to :day
  validates :name, presence: true
end
