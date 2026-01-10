# frozen_string_literal: true

# Model representing a trip with multiple days
class Trip < ApplicationRecord
  has_many :days,
           -> { order('start_at') },
           dependent: :destroy
  validates :name, presence: true
end
