# frozen_string_literal: true

require 'system_helper'
# for debug with inspector/irb put page.driver.debug(binding)

RSpec.describe 'trips', type: :system, vcr: false do
  let(:existing_trips) { nil }

  before do
    existing_trips
    visit '/'
  end

  describe 'new trip' do
    let(:name) { 'new trip' }
    let(:description) { 'new description' }

    before do
      click_link 'add'

      fill_in 'trip_name', with: name
      fill_in 'trip_description', with: description
      click_button 'done'
    end

    it 'shows toast' do
      expect(page).to have_text('Trip was successfully created.')
    end

    it 'shows trip name' do
      expect(page).to have_text(name)
    end

    it 'shows trip description' do
      expect(page).to have_text(description)
    end

    describe 'modify the trip' do
      let(:name) { 'modified trip' }

      before do
        click_link 'settings'

        fill_in 'trip_name', with: name
        click_button 'done'
      end

      it 'shows modified name' do
        expect(page).to have_text(name)
      end
    end

    describe 'destroy the trip' do
      before do
        click_link 'settings'
        click_button 'delete'
      end

      it 'shows toast' do
        expect(page).to have_text('Trip was successfully destroyed.')
      end
    end
  end

  describe 'trip list' do
    describe 'blank trip' do
      let(:existing_trips) { FactoryBot.create(:blank_trip) }

      it 'shows the name' do
        expect(page).to have_text(existing_trips.name)
      end
    end

    describe 'single day trip' do
      let(:existing_trips) { FactoryBot.create(:single_day_trip) }

      it'shows the name' do
        expect(page).to have_text(existing_trips.name)
      end

      it 'shows 1st day date' do
        expect(page).to have_text('2022-01-01 - 2022-01-01')
      end
    end

    describe 'two days trip' do
      let(:existing_trips) { FactoryBot.create(:two_days_trip) }

      it 'shows 1st day date' do
        expect(page).to have_text('2022-01-01 - 2022-01-02')
      end
    end

    describe 'three days trip' do
      let(:existing_trips) { FactoryBot.create(:three_days_trip) }

      it 'shows 1st day date' do
        expect(page).to have_text('2022-01-01 - 2022-01-03')
      end
    end
  end
end
