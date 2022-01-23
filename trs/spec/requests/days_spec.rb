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

RSpec.describe '/days', type: :request do
  describe 'GET /index' do
    it 'renders a successful response' do
      day = FactoryBot.create(:day)
      get trip_days_url(day.trip)
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      day = FactoryBot.create(:unoptimized_day)
      VCR.use_cassette 'valhalla_route' do
        get trip_day_url(day.trip, day)
      end
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      trip = FactoryBot.create(:trip)
      get new_trip_day_url(trip)
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      day = FactoryBot.create(:day)
      get edit_trip_day_url(day.trip, day)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    let!(:trip) { FactoryBot.create(:trip) }

    context 'with valid parameters' do
      let(:attributes) { FactoryBot.attributes_for(:day) }

      it 'creates a new Day' do
        expect {
          post trip_days_url(trip), params: { day: attributes }
        }.to change(trip.days, :count).by(1)
      end

      it 'redirects to the created day' do
        post trip_days_url(trip), params: { day: attributes }
        expect(response).to redirect_to(trip)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: '' } }

      it 'does not create a new Day' do
        expect {
          post trip_days_url(trip), params: { day: invalid_attributes }
        }.to change(Day, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post trip_days_url(trip), params: { day: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    let(:day) { FactoryBot.create(:day) }

    context 'with valid parameters' do
      let(:new_attributes) {
        { name: 'new name' }
      }

      before do
        patch trip_day_url(day.trip, day), params: { day: new_attributes }
        day.reload
      end

      it 'updates the requested day' do
        expect(day.name).to eq new_attributes[:name]
      end

      it 'redirects to the day' do
        expect(response).to redirect_to(trip_day_url(day.trip, day))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch trip_day_url(day.trip, day), params: { day: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:day) { FactoryBot.create(:day) }

    it 'destroys the requested day' do
      expect {
        delete trip_day_url(day.trip, day)
      }.to change(Day, :count).by(-1)
    end

    it 'redirects to the days list' do
      delete trip_day_url(day.trip, day)
      expect(response).to redirect_to(trip_url(day.trip))
    end
  end

  describe 'POST /order_waypoints' do
    let(:day1) { FactoryBot.create(:unoptimized_day) }
    let(:day2) { FactoryBot.create(:day, trip: day1.trip) }

    describe 'in single day' do
      let(:waypoints) { day1.waypoints.map(&:id).reverse }

      # rubocop:disable RSpec/ExampleLength
      it 'set order of waypoints' do
        VCR.use_cassette 'valhalla_reordered_route' do
          post order_waypoints_trip_day_url(day1.trip, day1),
               params: {
                 waypoints_order: {
                   to: {
                     day_id: day1.id,
                     waypoints: waypoints,
                   },
                 }.to_json,
               }
        end

        actual = day1.waypoints.tap(&:reload).sort { |a, b| a.index <=> b.index }.map(&:id)
        expect(actual).to eq waypoints
      end
      # rubocop:enable RSpec/ExampleLength
    end

    describe 'in two days' do
      before do
        @waypoints1 = day1.waypoints.map(&:id)
        moved = @waypoints1.pop
        @waypoints2 = day2.waypoints.map(&:id) + [moved]

        post order_waypoints_trip_day_url(day1.trip, day1),
             params: {
               waypoints_order: {
                 from: {
                   day_id: day1.id,
                   waypoints: @waypoints1,
                 },
                 to: {
                   day_id: day2.id,
                   waypoints: @waypoints2,
                 },
               }.to_json,
             }
      end

      it 'set order of waypoints1' do
        actual1 = day1.waypoints.tap(&:reload).sort { |a, b| a.index <=> b.index }.map(&:id)
        expect(actual1).to eq @waypoints1
      end

      it 'set order of waypoints2' do
        actual2 = day2.waypoints.tap(&:reload).sort { |a, b| a.index <=> b.index }.map(&:id)
        expect(actual2).to eq @waypoints2
      end
    end
  end
end
