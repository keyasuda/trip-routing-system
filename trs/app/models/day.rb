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

  # ルート計算用に始点終点込みで並べたwaypointsを返す
  def ordered_waypoints
    [start_waypoint, stops, end_waypoint].flatten
  end

  def optimize!(costing = 'auto')
    locations = ordered_waypoints.map do |w|
      { 'lat' => w.latitude, 'lon' => w.longitude }
    end
    payload = { 'locations' => locations, 'costing' => costing }

    ret = Faraday.get('http://localhost:8002/optimized_route', { json: payload.to_json })
    result = JSON.parse(ret.body)

    locations = result['trip']['locations']
    targets = ordered_waypoints
    Waypoint.transaction do
      locations.each_with_index do |l, i|
        t = targets[l['original_index']]
        t.update(index: i)
      end
    end
  end
end
