# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Waypoint, type: :model do
  describe 'POI name search' do
    it 'searches POIs by keyword' do
      actual =
        VCR.use_cassette 'nominatim_nojimazaki' do
          described_class.search_poi('野島埼灯台')
        end
      expect(actual).to eq JSON.parse('[{"place_id":7105954,"licence":"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright","osm_type":"way","osm_id":456851139,"boundingbox":["34.901698","34.9017639","139.8883454","139.8884254"],"lat":"34.9017295","lon":"139.88838524561388","display_name":"野島埼灯台, 国道410号, 白浜町白浜, 南房総市, 千葉県, 2950102, 日本","place_rank":30,"category":"man_made","type":"lighthouse","importance":0.11100000000000002}]') # rubocop:disable Layout/LineLength
    end
  end
end
