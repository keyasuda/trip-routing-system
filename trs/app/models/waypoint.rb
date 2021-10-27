# frozen_string_literal: true

class Waypoint < ApplicationRecord
  belongs_to :day
  validates :name, presence: true

  def self.search_poi(keyword)
    ret = Faraday.get("http://localhost:8003/search?q=#{ERB::Util.u(keyword)}")
    JSON.parse(ret.body)
  end
end
