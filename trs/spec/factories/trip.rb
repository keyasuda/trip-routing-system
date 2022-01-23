# frozen_string_literal: true

FactoryBot.define do
  factory :trip do
    sequence(:name) { |i| "name #{i}" }
    sequence(:description) { |i| "description #{i}" }
    days { FactoryBot.build_list(:day, 10, trip: nil) }
  end

  factory :blank_trip, class: 'Trip' do
    sequence(:name) { |i| "name #{i}" }
    sequence(:description) { |i| "description #{i}" }
  end

  factory :single_day_trip, class: 'Trip' do
    name { 'single day trip' }
    days { [FactoryBot.build(:day20220101)] }
  end

  factory :two_days_trip, class: 'Trip' do
    name { 'two days trip' }
    days {
      [
        FactoryBot.build(:day20220101),
        FactoryBot.build(:day20220102),
      ]
    }
  end

  factory :three_days_trip, class: 'Trip' do
    name { 'three days trip' }
    days {
      [
        FactoryBot.build(:day20220101),
        FactoryBot.build(:day20220102),
        FactoryBot.build(:day20220103),
      ]
    }
  end
end
