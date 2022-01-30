# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Day, type: :model do
  describe 'accessors for waypoints' do
    before do
      @day = FactoryBot.create(:filled_trip).days.first
      @waypoints = @day.waypoints.shuffle
      @waypoints.each_with_index { |w, i| w.update(index: i) }
    end

    it 'gets all points, sorted' do
      expect(@day.ordered_waypoints).to eq @waypoints
    end
  end

  describe 'routes' do
    let(:day) { FactoryBot.create(:unoptimized_day) }

    describe 'optimizer' do
      it 'optimizeses waypoints order' do
        VCR.use_cassette 'valhalla_optimized_route' do
          day.optimize!
        end

        expect(day.ordered_waypoints.map(&:name)).to eq %w[0 1 4 3 2 5]
      end
    end

    describe 'presentation' do
      it 'gets routes' do
        actual = VCR.use_cassette 'valhalla_route' do
          day.routes
        end

        expect(actual.flat_map(&:keys).uniq).to eq %w[maneuvers summary shape]
      end
    end
  end
end
