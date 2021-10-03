# frozen_string_literal: true

json.array! @days, partial: 'days/day', as: :day
