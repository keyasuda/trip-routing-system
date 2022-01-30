# frozen_string_literal: true

require 'rails_helper'

Capybara.default_normalize_ws = true

require 'capybara/cuprite'
Capybara.javascript_driver = :cuprite_driver
Capybara.register_driver(:cuprite_driver) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1200, 800],
    inspector: true,
    headless: true,
  )
end

RSpec.configure do |config|
  # Add #dom_id support
  config.include ActionView::RecordIdentifier, type: :system

  # Make sure this hook runs before others
  config.prepend_before(:each, type: :system) do
    driven_by :cuprite_driver
    WebMock.disable!
  end

  config.append_after(:each, type: :system) do
    WebMock.enable!
  end
end
