# frozen_string_literal: true

json.extract! day, :id, :name, :description, :start_waypoint_id, :end_waypoint_id, :start_at, :trip_id, :created_at, :updated_at
json.url day_url(day, format: :json)
