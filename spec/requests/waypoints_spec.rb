# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/waypoints', type: :request do
  let!(:waypoint) { FactoryBot.create(:waypoint) }
  let(:day) { waypoint.day }
  let(:trip) { day.trip }

  let(:valid_attributes) {
    FactoryBot.attributes_for(:waypoint).tap { |a| a.delete(:index) }
  }

  let(:invalid_attributes) {
    { name: '' }
  }

  describe 'GET /edit' do
    it 'render a successful response' do
      get edit_trip_day_waypoint_url(trip, day, waypoint)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Waypoint' do
        expect {
          post trip_day_waypoints_url(trip, day), params: { waypoint: valid_attributes }
        }.to change(day.waypoints, :count).by(1)
      end

      it 'redirects to the created waypoint' do
        post trip_day_waypoints_url(trip, day), params: { waypoint: valid_attributes }
        expect(response).to redirect_to(trip_day_url(trip, day))
      end

      it 'creates a waypoint with index' do
        post trip_day_waypoints_url(trip, day), params: { waypoint: valid_attributes }
        day.waypoints.reload
        expect(day.waypoints.last.index).to eq day.waypoints.size
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Waypoint' do
        expect {
          post trip_day_waypoints_url(trip, day), params: { waypoint: invalid_attributes }
        }.to change(day.waypoints, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post trip_day_waypoints_url(trip, day), params: { waypoint: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) {
        { name: 'new name' }
      }

      it 'updates the requested waypoint' do
        patch trip_day_waypoint_url(trip, day, waypoint), params: { waypoint: new_attributes }
        waypoint.reload
        expect(waypoint.name).to eq new_attributes[:name]
      end

      it 'redirects to the waypoint' do
        patch trip_day_waypoint_url(trip, day, waypoint), params: { waypoint: new_attributes }
        waypoint.reload
        expect(response).to redirect_to(trip_day_url(trip, day))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch trip_day_waypoint_url(trip, day, waypoint), params: { waypoint: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested waypoint' do
      expect {
        delete trip_day_waypoint_url(trip, day, waypoint)
      }.to change(day.waypoints, :count).by(-1)
    end

    it 'redirects to the waypoints list' do
      delete trip_day_waypoint_url(trip, day, waypoint)
      expect(response).to redirect_to(trip_day_url(trip, day))
    end
  end
end