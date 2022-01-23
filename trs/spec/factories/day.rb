# frozen_string_literal: true

FactoryBot.define do
  factory :day do
    sequence(:name) { |i| "name #{i}" }
    sequence(:description) { |i| "description #{i}" }
    waypoints { FactoryBot.build_list(:waypoint, 10, day: nil) }
    trip
  end

  factory :unoptimized_day, class: 'Day' do
    name { 'unoptimized' }
    waypoints { (0..5).map { |i| FactoryBot.build(:"waypoint#{i}", day: nil) } }
    start_at { '2021/03/01 10:00:00' }
    trip
  end

  factory :day20220101, class: 'Day' do
    name { 'day20220101' }
    start_at { '2022/01/01 10:00:00' }
    trip
  end

  factory :day20220102, class: 'Day' do
    name { 'day20220102' }
    start_at { '2022/01/02 10:00:00' }
    trip
  end

  factory :day20220103, class: 'Day' do
    name { 'day20220103' }
    start_at { '2022/01/03 10:00:00' }
    trip
  end
end
