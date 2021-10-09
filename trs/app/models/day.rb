# frozen_string_literal: true

class Day < ApplicationRecord
  belongs_to :trip
  has_many :waypoints, dependent: :destroy
  validates :name, presence: true

  def start_waypoint
    waypoints.find { |w| w.id == start_waypoint_id }
  end

  def start_waypoint=(point)
    self.start_waypoint_id = point.id
  end

  def end_waypoint
    waypoints.find { |w| w.id == end_waypoint_id }
  end

  def end_waypoint=(point)
    self.end_waypoint_id = point.id
  end

  def stops
    waypoints.reject { |w| [start_waypoint_id, end_waypoint_id].include?(w.id) }.sort { |a, b| a.index <=> b.index }
  end
end
