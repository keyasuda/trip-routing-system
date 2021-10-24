# frozen_string_literal: true

FactoryBot.define do
  factory :waypoint do
    sequence(:name) { |i| "name #{i}" }
    sequence(:description) { |i| "description #{i}" }
    sequence(:longitude) { |i| i }
    sequence(:latitude) { |i| i }
    sequence(:stop_min) { |i| i }
    sequence(:index) { |i| i }
    day
  end

  factory :waypoint0, class: 'Waypoint' do
    name { '0' }
    longitude { 135.2290713787079 }
    latitude { 34.6374142336271 }
    index { 0 }
  end

  factory :waypoint1, class: 'Waypoint' do
    name { '1' }
    longitude { 135.48587143421176 }
    latitude { 34.79153242075143 }
    index { 1 }
  end

  factory :waypoint2, class: 'Waypoint' do
    name { '2' }
    longitude { 134.85790729522708 }
    latitude { 35.10142495567171 }
    index { 2 }
  end

  factory :waypoint3, class: 'Waypoint' do
    name { '3' }
    longitude { 134.9738055467606 }
    latitude { 34.69963668110303 }
    index { 3 }
  end

  factory :waypoint4, class: 'Waypoint' do
    name { '4' }
    longitude { 134.99967813491824 }
    latitude { 34.56775073642461 }
    index { 4 }
  end

  factory :waypoint5, class: 'Waypoint' do
    name { '5' }
    longitude { 134.98839139938357 }
    latitude { 34.80774284635084 }
    index { 5 }
  end
end
