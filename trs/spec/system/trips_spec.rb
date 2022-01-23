# frozen_string_literal: true

require 'system_helper'
# for debug with inspector/irb put page.driver.debug(binding)

RSpec.describe 'trips', type: :system, vcr: false do
  before do
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
end
