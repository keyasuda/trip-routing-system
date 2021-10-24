# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WaypointsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/trips/3/days/2/waypoints').not_to route_to('waypoints#index', trip_id: '3', day_id: '2')
    end

    it 'routes to #new' do
      expect(get: '/trips/3/days/2/waypoints/new').not_to route_to('waypoints#new', trip_id: '3', day_id: '2')
    end

    it 'routes to #show' do
      expect(get: '/trips/3/days/2/waypoints/1').not_to route_to('waypoints#show', id: '1', trip_id: '3', day_id: '2')
    end

    it 'routes to #edit' do
      expect(get: '/trips/3/days/2/waypoints/1/edit').to route_to('waypoints#edit', id: '1', trip_id: '3', day_id: '2')
    end

    it 'routes to #create' do
      expect(post: '/trips/3/days/2/waypoints').to route_to('waypoints#create', trip_id: '3', day_id: '2')
    end

    it 'routes to #update via PUT' do
      expect(put: '/trips/3/days/2/waypoints/1').to route_to('waypoints#update', id: '1', trip_id: '3', day_id: '2')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/trips/3/days/2/waypoints/1').to route_to('waypoints#update', id: '1', trip_id: '3', day_id: '2')
    end

    it 'routes to #destroy' do
      expect(delete: '/trips/3/days/2/waypoints/1').to route_to('waypoints#destroy', id: '1', trip_id: '3', day_id: '2')
    end
  end
end
