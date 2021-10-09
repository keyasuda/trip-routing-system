# frozen_string_literal: true

FactoryBot.define do
  factory :day do
    sequence(:name) { |i| "name #{i}" }
    sequence(:description) { |i| "description #{i}" }
    waypoints { FactoryBot.build_list(:waypoint, 10, day: nil) }
  end

  factory :unoptimized_day, class: 'Day' do
    name { 'unoptimized' }
    waypoints { (0..5).map { |i| FactoryBot.build(:"waypoint#{i}", day: nil) } }
    trip

    after(:create) do |d|
      d.start_waypoint_id = d.waypoints.first.id
      d.end_waypoint_id = d.waypoints.last.id
    end
  end
end
