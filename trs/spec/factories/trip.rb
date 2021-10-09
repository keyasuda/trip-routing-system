# frozen_string_literal: true

FactoryBot.define do
  factory :trip do
    sequence(:name) { |i| "name #{i}" }
    sequence(:description) { |i| "description #{i}" }
    days { FactoryBot.build_list(:day, 10, trip: nil) }
  end
end
