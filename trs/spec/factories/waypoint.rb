# frozen_string_literal: true

FactoryBot.define do
  factory :waypoint do
    sequence(:name) { |i| "name #{i}" }
    sequence(:description) { |i| "description #{i}" }
    sequence(:longitude) { |i| i }
    sequence(:latitude) { |i| i }
    sequence(:stop_min) { |i| i }
    sequence(:index) { |i| i }
  end
end
