# frozen_string_literal: true

require 'plus_codes/open_location_code'

class Waypoint < ApplicationRecord
  belongs_to :day
  validates :name, presence: true

  def plus_code
    PlusCodes::OpenLocationCode.new.encode(latitude, longitude)
  end

  def self.search_poi(keyword)
    m = keyword.match(/\A([2-9CFGHJMPQRVWX]+\+[2-9CFGHJMPQRV
 WX]+) ?(.*?)\z/)

    if m
      # plus codeが与えられた場合
      olc = PlusCodes::OpenLocationCode.new
      decoded_pluscode =
        if m[2].blank?
          olc.decode(keyword)
        else
          # short code
          # reference locationの座標を得る
          ref = self.call_nominatim(m[2]).first
          full_code = olc.recover_nearest(m[1].strip, ref[:lat], ref[:lon])
          olc.decode(full_code)
        end

      [{
        lat: decoded_pluscode.latitude_center,
        lon: decoded_pluscode.longitude_center,
        display_name: keyword,
      }]
    else
      # それ以外
      self.call_nominatim(keyword)
    end
  end

  def self.call_nominatim(keyword)
    ret = Faraday.get("http://localhost:8003/search?q=#{ERB::Util.u(keyword)}")
    results = JSON.parse(ret.body)

    results.map { |r|
      {
        lat: r['lat'].to_f,
        lon: r['lon'].to_f,
        display_name: r['display_name'],
      }
    }
  end
end
