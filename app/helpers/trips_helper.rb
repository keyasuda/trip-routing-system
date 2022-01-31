# frozen_string_literal: true

module TripsHelper
  def google_map_url(day)
    [
      'https://www.google.co.jp/maps/dir', day.ordered_waypoints.map(&:plus_code).map { |c| ERB::Util.u(c) }
    ].flatten.join('/')
  end
end
