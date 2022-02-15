# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Waypoint, type: :model do
  describe 'POI name search' do
    it 'searches POIs by keyword' do
      actual =
        VCR.use_cassette 'nominatim_nojimazaki' do
          described_class.search_poi('野島埼灯台')
        end
      expect(actual).to eq [{ lat: 34.9017295, lon: 139.88838524561388, display_name: '野島埼灯台, 国道410号, 白浜町白浜, 南房総市, 千葉県, 2950102, 日本' }]
    end
  end

  context 'plus code' do
    describe 'return plus code of the waypoint' do
      let(:waypoint) { FactoryBot.build(:heso) }

      it 'returns valid full plus code' do
        expect(waypoint.plus_code).to eq '8Q7Q2222+22'
      end
    end

    describe 'plus codes decoding' do
      let(:code) { '8Q7Q2222+22' }
      let(:heso) { { lat: 35.0000625, lon: 135.0000625, display_name: '日本のへそモニュメント, 西脇篠山線, 上比延町, 西脇市, 兵庫県, 日本' } }

      it 'decodes full codes' do
        actual =
          VCR.use_cassette 'nominatim_nishiwaki' do
            described_class.search_poi(code)
          end
        expect(actual).to eq [heso]
      end

      describe 'short codes' do
        let(:code) { '2222+22 西脇市、兵庫県' }

        it 'decodes the short codes' do
          actual =
            VCR.use_cassette 'nominatim_nishiwaki' do
              described_class.search_poi(code)
            end
          expect(actual).to eq [heso]
        end
      end

      describe 'too long codes' do
        let(:code) { "#{'2' * 28}+22" }

        it 'wont decode it as a plus code' do
          actual =
            VCR.use_cassette 'nominatim_toolongpluscode' do
              described_class.search_poi(code)
            end
          expect(actual).to eq []
        end
      end
    end
  end
end
