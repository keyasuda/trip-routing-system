# frozen_string_literal: true

class Trip < ApplicationRecord
  validates :name, presence: true
end
