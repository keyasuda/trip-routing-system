# frozen_string_literal: true

class Trip < ApplicationRecord
  has_many :days,
           -> { order('start_at') },
           dependent: :destroy
  validates :name, presence: true
end
