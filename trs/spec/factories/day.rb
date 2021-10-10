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
  end
end
