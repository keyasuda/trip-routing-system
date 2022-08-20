# frozen_string_literal: true

module DaysHelper
  def waypoint_eta(day, index)
    offset =
      day.routes[0, index].map { |r| r['summary']['time'].to_f }.compact.reduce(:+).to_i +
      (day.ordered_waypoints[0, index].map(&:stop_min).compact.reduce(:+).to_i * 60)

    offset.seconds.since(day.start_at)
  end

  def enroute(day, index)
    return nil if day.routes[index].blank?

    summary = day.routes[index]['summary']
    t = summary['time'] / 60
    d = summary['length']

    { time: t.to_i, distance: d.to_i }
  end
end
