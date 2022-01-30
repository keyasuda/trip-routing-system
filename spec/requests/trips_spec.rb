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

RSpec.describe '/trips', type: :request do
  # Trip. As you add validations to Trip, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryBot.attributes_for(:trip)
  }

  let(:invalid_attributes) {
    { name: '' }
  }

  describe 'GET /index' do
    it 'renders a successful response' do
      Trip.create! valid_attributes
      get trips_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      trip = Trip.create! valid_attributes
      get trip_url(trip)
      expect(response).to be_successful
    end
  end

  describe 'GET /show.ics' do
    before do
      VCR.use_cassette 'valhalla_route' do
        get trip_url(trip, format: :ics)
      end
    end

    let(:trip) { FactoryBot.create(:unoptimized_day).trip }

    it 'renders a successful response' do
      expect(response).to be_successful
    end

    it 'returns waypoints in ICS' do
      actual = Icalendar::Calendar.parse(response.body).first
      trip.days.each do |day|
        day.ordered_waypoints.each.with_index do |w, i|
          event = actual.events[i]
          expect(event.summary).to eq w.name
          expect(event.location).to eq w.plus_code
          expect(event.dtend).to eq (w.stop_min || 0).minutes.since(event.dtstart)
        end
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_trip_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      trip = Trip.create! valid_attributes
      get edit_trip_url(trip)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Trip' do
        expect {
          post trips_url, params: { trip: valid_attributes }
        }.to change(Trip, :count).by(1)
      end

      it 'redirects to the created trip' do
        post trips_url, params: { trip: valid_attributes }
        expect(response).to redirect_to(trip_url(Trip.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Trip' do
        expect {
          post trips_url, params: { trip: invalid_attributes }
        }.to change(Trip, :count).by(0)
      end

      it 'returns error response' do
        post trips_url, params: { trip: invalid_attributes }
        expect(response.successful?).to be false
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) {
        { name: 'new name' }
      }

      it 'updates the requested trip' do
        trip = Trip.create! valid_attributes
        patch trip_url(trip), params: { trip: new_attributes }
        trip.reload
        expect(trip.name).to eq new_attributes[:name]
      end

      it 'redirects to the trip' do
        trip = Trip.create! valid_attributes
        patch trip_url(trip), params: { trip: new_attributes }
        trip.reload
        expect(response).to redirect_to(trip_url(trip))
      end
    end

    context 'with invalid parameters' do
      it 'returns failure response' do
        trip = Trip.create! valid_attributes
        patch trip_url(trip), params: { trip: invalid_attributes }
        expect(response.successful?).to be false
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested trip' do
      trip = Trip.create! valid_attributes
      expect {
        delete trip_url(trip)
      }.to change(Trip, :count).by(-1)
    end

    it 'redirects to the trips list' do
      trip = Trip.create! valid_attributes
      delete trip_url(trip)
      expect(response).to redirect_to(trips_url)
    end
  end
end