# frozen_string_literal: true

class Trip < ApplicationRecord
  has_many :days, dependent: :destroy
  validates :name, presence: true
end
