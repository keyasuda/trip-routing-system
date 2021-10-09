# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Day, type: :model do
  describe 'accessors for waypoints' do
    before do
      @day = FactoryBot.create(:trip).days.first
      @waypoints = @day.waypoints.shuffle
      @start_w = @waypoints.shift
      @end_w = @waypoints.pop
      @day.update(start_waypoint_id: @start_w.id, end_waypoint_id: @end_w.id)
      @waypoints.each_with_index { |w, i| w.update(index: i) }
    end

    it 'gets the starting point' do
      expect(@day.start_waypoint).to eq @start_w
    end

    it 'updates the starting point' do
      target = @day.waypoints.reject { |w| [@start_w, @end_w].map(&:id).include?(w.id) }.sample
      @day.start_waypoint = target
      @day.start_waypoint_id = target.id
    end

    it 'gets the goal' do
      expect(@day.end_waypoint).to eq @end_w
    end

    it 'updates the goal' do
      target = @day.waypoints.reject { |w| [@start_w, @end_w].map(&:id).include?(w.id) }.sample
      @day.end_waypoint = target
      @day.end_waypoint_id = target.id
    end

    it 'gets waypoints order by index' do
      expect(@day.stops).to eq @waypoints
    end

    it 'gets all points, sorted' do
      expect(@day.ordered_waypoints).to eq [@start_w, @waypoints, @end_w].flatten
    end
  end

  describe 'route optimizer' do
    let(:day) { FactoryBot.create(:unoptimized_day) }

    it 'optimizeses waypoints order' do
      VCR.use_cassette 'valhalla_optimized_route' do
        day.optimize!
      end

      expect(day.stops.map(&:name)).to eq %w[1 4 3 2]
    end
  end
end
