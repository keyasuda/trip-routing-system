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
    attributes_for(:trip)
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

    it 'renders only targeted user trips' do
      trip1 = create(:trip, username: 'user1')
      trip2 = create(:trip, username: 'user2')
      get trips_url, headers: { 'X-Forwarded-User' => 'user1' }
      expect(response.body).to include(trip1.name)
      expect(response.body).not_to include(trip2.name)
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      trip = Trip.create! valid_attributes
      get trip_url(trip)
      expect(response).to be_successful
    end

    it 'renders the trip of the user' do
      trip = create(:trip, username: 'user1')
      get trip_url(trip), headers: { 'X-Forwarded-User' => 'user1' }
      expect(response).to be_successful
    end

    it 'wont render the trip of other user' do
      trip = create(:trip, username: 'user2')
      get trip_url(trip), headers: { 'X-Forwarded-User' => 'user1' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /show.ics' do
    before do
      VCR.use_cassette 'valhalla_route' do
        get trip_url(trip, format: :ics), headers:
      end
    end

    let(:trip) { create(:unoptimized_day).trip }
    let(:headers) { {} }

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

    describe 'matched user' do
      let(:trip) { create(:unoptimized_day).trip.tap { |t| t.update(username: 'user1') } }
      let(:headers) { { 'X-Forwarded-User' => 'user1' } }

      it 'renders a successful response' do
        expect(response).to be_successful
      end
    end

    describe 'unmatched user' do
      let(:trip) { create(:unoptimized_day).trip.tap { |t| t.update(username: 'user2') } }
      let(:headers) { { 'X-Forwarded-User' => 'user1' } }

      it 'renders 404' do
        expect(response).to have_http_status(:not_found)
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

    it 'renders the trip of the user' do
      trip = create(:trip, username: 'user1')
      get edit_trip_url(trip), headers: { 'X-Forwarded-User' => 'user1' }
      expect(response).to be_successful
    end

    it 'wont render the trip of other user' do
      trip = create(:trip, username: 'user2')
      get edit_trip_url(trip), headers: { 'X-Forwarded-User' => 'user1' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Trip' do
        expect {
          post trips_url, params: { trip: valid_attributes }
        }.to change(Trip, :count).by(1)
      end

      it 'creates a new Trip with username' do
        expect {
          post trips_url,
               params: { trip: valid_attributes },
               headers: { 'X-Forwarded-User' => 'user1' }
        }.to change(Trip, :count).by(1)
        expect(Trip.last.username).to eq 'user1'
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
        }.not_to change(Trip, :count)
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

      it 'updates the owned trip' do
        trip = create(:trip, username: 'user1')
        patch trip_url(trip),
              params: { trip: new_attributes },
              headers: { 'X-Forwarded-User' => 'user1' }
        trip.reload
        expect(trip.name).to eq new_attributes[:name]
      end

      it 'wont update the others trip' do
        trip = create(:trip, username: 'user2')
        patch trip_url(trip),
              params: { trip: new_attributes },
              headers: { 'X-Forwarded-User' => 'user1' }
        trip.reload
        expect(response).to have_http_status(:not_found)
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

    it 'destroys the owned trip' do
      trip = create(:trip, username: 'user1')
      expect {
        delete trip_url(trip), headers: { 'X-Forwarded-User' => 'user1' }
      }.to change(Trip, :count).by(-1)
    end

    it 'wont destroy the others trip' do
      trip = create(:trip, username: 'user2')
      expect {
        delete trip_url(trip), headers: { 'X-Forwarded-User' => 'user1' }
      }.not_to change(Trip, :count)
    end
  end
end
