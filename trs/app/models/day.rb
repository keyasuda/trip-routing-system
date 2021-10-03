# frozen_string_literal: true

class Day < ApplicationRecord
  belongs_to :trip
  has_many :waypoints, dependent: :destroy
  validates :name, presence: true
end
