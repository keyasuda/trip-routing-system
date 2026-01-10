# frozen_string_literal: true

require 'plus_codes/open_location_code'

# Model representing a waypoint within a day
class Waypoint < ApplicationRecord
  belongs_to :day
  validates :name, presence: true

  def plus_code
    PlusCodes::OpenLocationCode.new.encode(latitude, longitude)
  end

  def self.search_poi(keyword)
    m =
      if keyword.length <= 30
        keyword.match(/\A([2-9CFGHJMPQRVWX]+\+[2-9CFGHJMPQRV
 WX]+) ?(.*?)\z/)
      end

    if m
      # plus codeが与えられた場合
      [self.decode_matched_plus_code(m)]
    else
      # それ以外
      self.call_nominatim(keyword)
    end
  end

  def self.decode_matched_plus_code(matched)
    olc = PlusCodes::OpenLocationCode.new
    decoded =
      if matched[2].blank?
        olc.decode(matched.to_s)
      else
        # short code
        # reference locationの座標を得る
        ref = call_nominatim(matched[2]).first
        full_code = olc.recover_nearest(matched[1].strip, ref[:lat], ref[:lon])
        olc.decode(full_code)
      end

    {
      lat: decoded.latitude_center,
      lon: decoded.longitude_center,
      display_name: get_display_name(decoded),
    }
  end

  def self.call_nominatim(keyword)
    ret = Faraday.get("#{Settings.search}/search?q=#{ERB::Util.u(keyword)}")
    results = JSON.parse(ret.body)

    results.map do |r|
      {
        lat: r['lat'].to_f,
        lon: r['lon'].to_f,
        display_name: r['display_name'],
      }
    end
  end

  def self.get_display_name(pos)
    ret = Faraday.get("#{Settings.search}/reverse?lat=#{pos.latitude_center}&lon=#{pos.longitude_center}&format=json")
    JSON.parse(ret.body)['display_name']
  end
end
