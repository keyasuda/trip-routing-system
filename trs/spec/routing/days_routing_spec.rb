# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DaysController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/trips/1/days').to route_to('days#index', trip_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/trips/1/days/new').to route_to('days#new', trip_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/trips/1/days/1').to route_to('days#show', id: '1', trip_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/trips/1/days/1/edit').to route_to('days#edit', id: '1', trip_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/trips/1/days').to route_to('days#create', trip_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/trips/1/days/1').to route_to('days#update', id: '1', trip_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/trips/1/days/1').to route_to('days#update', id: '1', trip_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/trips/1/days/1').to route_to('days#destroy', id: '1', trip_id: '1')
    end
  end
end
