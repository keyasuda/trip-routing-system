# frozen_string_literal: true

FactoryBot.define do
  factory :day do
    sequence(:name) { |i| "name #{i}" }
    sequence(:description) { |i| "description #{i}" }
    waypoints { FactoryBot.build_list(:waypoint, 10, day: nil) }
  end
end
