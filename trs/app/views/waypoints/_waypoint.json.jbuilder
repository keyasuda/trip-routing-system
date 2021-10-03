# frozen_string_literal: true

json.extract! waypoint, :id, :name, :description, :longitude, :latitude, :stop_min, :index, :day_id, :created_at, :updated_at
json.url waypoint_url(waypoint, format: :json)
