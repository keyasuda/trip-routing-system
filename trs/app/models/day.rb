# frozen_string_literal: true

class Day < ApplicationRecord
  belongs_to :trip
  validates :name, presence: true
end
