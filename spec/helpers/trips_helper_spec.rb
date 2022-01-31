# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripsHelper, type: :helper do
  let(:day) { FactoryBot.create(:unoptimized_day) }

  it 'returns Google map URL with plus code of waypoints' do
    expect(helper.google_map_url(day)).to eq ['https://www.google.co.jp/maps/dir', day.ordered_waypoints.map(&:plus_code).map { |c|
                                                                                     ERB::Util.u(c)
                                                                                   }].flatten.join('/')
  end
end
