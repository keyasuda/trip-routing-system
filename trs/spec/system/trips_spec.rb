# frozen_string_literal: true

require 'system_helper'
# for debug with inspector/irb put page.driver.debug(binding)

RSpec.describe 'trips', type: :system, vcr: false do
  before do
    visit '/'
  end

  describe 'new trip' do
    before do
      click_link 'add'

      fill_in 'trip_name', with: 'new trip'
      fill_in 'trip_description', with: 'new description'
      click_button 'done'
    end

    it 'shows toast' do
      expect(page).to have_text('Trip was successfully created.')
    end

    it 'shows trip name' do
      expect(page).to have_text('new trip')
    end

    it 'shows trip description' do
      expect(page).to have_text('new description')
    end
  end
end
