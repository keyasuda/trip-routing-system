# frozen_string_literal: true

module DaysHelper
  def waypoint_eta(day, index)
    offset =
      day.routes[0, index].map { |r| r['summary']['time'].to_f }.compact.reduce(:+).to_i +
      day.waypoints[0, index].map(&:stop_min).compact.reduce(:+).to_i * 60

    offset.seconds.since(day.start_at)
  end
end
