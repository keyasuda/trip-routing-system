# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DaysHelper, type: :helper do
  describe 'eta output' do
    subject do
      VCR.use_cassette 'valhalla_route' do
        helper.waypoint_eta(day, index)
      end
    end

    let(:day) { FactoryBot.create(:unoptimized_day) }
    let(:index) { 3 }

    describe 'mid waypoint' do
      it 'returns the eta' do
        is_expected.to eq 11_773.seconds.since(day.start_at)
      end
    end

    describe 'first waypoint' do
      let(:index) { 0 }

      it 'returns Day#start_at' do
        is_expected.to eq day.start_at
      end
    end
  end
end
